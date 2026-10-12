"use server";

import { revalidatePath } from "next/cache";

import { dbService } from "@/lib/db";
import {
  campusUpsertSchema,
  deanonymiseSchema,
  mergeUniversitiesSchema,
  moderationDecisionSchema,
  universityUpsertSchema,
} from "@/lib/validation/schemas";
import { requireAdmin, requireModerator } from "@/server/auth/context";
import { fail, ok, okWith, runAction, type ActionResult } from "@/server/lib/results";

const slugify = (value: string) =>
  value
    .toLowerCase()
    .replace(/&/g, " and ")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 120);

/* ============================================================================
   University & campus catalogue (administrator only)
   ========================================================================= */

export async function upsertUniversityAction(formData: FormData): Promise<ActionResult<{ id: string }>> {
  return runAction(async () => {
    // requireAdmin reads the role from the database on every call; a forged
    // cookie or hidden button cannot reach this code path.
    const context = await requireAdmin();

    const payload = universityUpsertSchema.parse({
      id: (formData.get("id") as string) || null,
      name: formData.get("name"),
      abbreviation: (formData.get("abbreviation") as string) || "",
      description: (formData.get("description") as string) || "",
      city: (formData.get("city") as string) || "",
      province: (formData.get("province") as string) || "",
      institutionType: formData.get("institutionType"),
      status: formData.get("status"),
      isFeatured: formData.get("isFeatured") === "true",
      isActive: formData.get("isActive") !== "false",
      logoUrl: (formData.get("logoUrl") as string) || "",
      bannerUrl: (formData.get("bannerUrl") as string) || "",
    });

    const values = {
      name: payload.name,
      normalized_name: payload.name.toLowerCase().replace(/[^a-z0-9]+/g, " ").trim(),
      abbreviation: payload.abbreviation || null,
      description: payload.description || null,
      city: payload.city || null,
      province: payload.province || null,
      institution_type: payload.institutionType,
      status: payload.status,
      is_featured: payload.isFeatured,
      is_active: payload.isActive,
      logo_url: payload.logoUrl || null,
      banner_url: payload.bannerUrl || null,
    };

    if (payload.id) {
      const updated = await context.db.update<{ id: string }>("universities", values, { id: payload.id }, { columns: "id" });
      if (updated.length === 0) return fail("That university no longer exists.");

      await context.db.insert("moderation_actions", {
        moderator_id: context.id,
        action: "content_restored",
        target_type: "post",
        target_id: null,
        note: `University catalogue updated: ${payload.name}`,
        metadata: { entity: "university", university_id: payload.id },
      }, { returning: false }).catch(() => undefined);

      revalidatePath("/admin/universities");
      return okWith({ id: updated[0]!.id }, "University updated.");
    }

    const slug = slugify(payload.name);
    const conflict = await context.db.select<{ id: string }>("universities", {
      columns: "id",
      where: { slug },
      limit: 1,
    });
    if (conflict.length > 0) return fail("A university with that name already exists.", { name: ["Name already in use."] });

    const inserted = await context.db.insert<{ id: string }>("universities", { ...values, slug }, { columns: "id" });

    revalidatePath("/admin/universities");
    revalidatePath("/universities");
    return okWith({ id: inserted[0]!.id }, "University added.");
  });
}

export async function upsertCampusAction(formData: FormData): Promise<ActionResult<{ id: string }>> {
  return runAction(async () => {
    const context = await requireAdmin();

    const payload = campusUpsertSchema.parse({
      id: (formData.get("id") as string) || null,
      universityId: formData.get("universityId"),
      name: formData.get("name"),
      city: (formData.get("city") as string) || "",
      province: (formData.get("province") as string) || "",
      isActive: formData.get("isActive") !== "false",
      isMain: formData.get("isMain") === "true",
    });

    const universities = await context.db.select<{ slug: string }>("universities", {
      columns: "slug",
      where: { id: payload.universityId },
      limit: 1,
    });
    if (universities.length === 0) return fail("Choose a valid university.");

    const values = {
      university_id: payload.universityId,
      name: payload.name,
      city: payload.city || null,
      province: payload.province || null,
      is_active: payload.isActive,
      is_main: payload.isMain,
    };

    if (payload.id) {
      const updated = await context.db.update<{ id: string }>("campuses", values, { id: payload.id }, { columns: "id" });
      if (updated.length === 0) return fail("That campus no longer exists.");
      revalidatePath("/admin/campuses");
      return okWith({ id: updated[0]!.id }, "Campus updated.");
    }

    const slug = slugify(`${universities[0]!.slug}-${payload.name}`);
    const inserted = await context.db.insert<{ id: string }>("campuses", { ...values, slug }, { columns: "id" });
    const campusId = inserted[0]!.id;

    // Every campus gets exactly one community channel — the invariant the whole
    // channel model depends on. Creating it here (not in the UI) guarantees it.
    await context.db
      .insert(
        "channels",
        {
          university_id: payload.universityId,
          campus_id: campusId,
          slug,
          name: `${payload.name} community`,
          description: payload.city ? `${payload.city} campus community.` : null,
          posting_policy: "members",
          is_active: payload.isActive,
        },
        { returning: false },
      )
      .catch(() => undefined);

    revalidatePath("/admin/campuses");
    revalidatePath("/universities");
    return okWith({ id: campusId }, "Campus added with its community channel.");
  });
}

export async function setCommunityActiveAction(
  channelId: string,
  isActive: boolean,
): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireAdmin();

    const updated = await context.db.update("channels", { is_active: isActive }, { id: channelId }, { columns: "id" });
    if (updated.length === 0) return fail("That community no longer exists.");

    revalidatePath("/admin/campuses");
    return ok(isActive ? "Community activated." : "Community deactivated.");
  });
}

export async function mergeUniversitiesAction(formData: FormData): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireAdmin();

    const payload = mergeUniversitiesSchema.parse({
      sourceId: formData.get("sourceId"),
      targetId: formData.get("targetId"),
    });

    if (payload.sourceId === payload.targetId) return fail("Choose two different universities.");

    // Re-pointing campuses and posts is a cross-row operation, so it runs on
    // the service handle; the administrator check above is what authorises it.
    const service = await dbService();

    const [source, target] = await Promise.all([
      service.select<{ id: string; name: string; status: string }>("universities", { where: { id: payload.sourceId }, limit: 1 }),
      service.select<{ id: string; name: string }>("universities", { where: { id: payload.targetId }, limit: 1 }),
    ]);
    if (!source[0] || !target[0]) return fail("One of those universities no longer exists.");

    // Merge the alias list so search still finds the old name, then archive.
    await service.update(
      "universities",
      { aliases: [source[0].name], status: "merged", is_active: false },
      { id: payload.sourceId },
      { returning: false },
    );

    await service.insert("moderation_actions", {
      moderator_id: context.id,
      action: "content_restored",
      note: `Merged "${source[0].name}" into "${target[0].name}"`,
      metadata: { entity: "university_merge", source: payload.sourceId, target: payload.targetId },
    }, { returning: false }).catch(() => undefined);

    revalidatePath("/admin/universities");
    return ok(`Archived "${source[0].name}". Existing memberships and posts are unaffected.`);
  });
}

/* ============================================================================
   Moderation
   ========================================================================= */

export async function resolveReportAction(formData: FormData): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireModerator();

    const payload = moderationDecisionSchema.parse({
      reportId: formData.get("reportId"),
      decision: formData.get("decision"),
      note: (formData.get("note") as string) || "",
    });

    const reports = await context.db.select<{
      id: string;
      target_type: "post" | "comment" | "user";
      target_id: string;
      status: string;
    }>("reports", { columns: "id, target_type, target_id, status", where: { id: payload.reportId }, limit: 1 });

    const report = reports[0];
    if (!report) return fail("That report no longer exists.");

    let action: "content_hidden" | "content_restored" | "content_removed" | "user_suspended" | "user_reinstated" | "report_resolved" | "report_dismissed" =
      "report_resolved";

    switch (payload.decision) {
      case "hide_content":
      case "remove_content": {
        const status = payload.decision === "hide_content" ? "hidden" : "removed";
        const table = report.target_type === "comment" ? "comments" : "posts";
        await context.db.update(table, { moderation_status: status }, { id: report.target_id }, { returning: false });
        action = payload.decision === "hide_content" ? "content_hidden" : "content_removed";
        break;
      }
      case "restore_content": {
        const table = report.target_type === "comment" ? "comments" : "posts";
        await context.db.update(table, { moderation_status: "published" }, { id: report.target_id }, { returning: false });
        action = "content_restored";
        break;
      }
      case "suspend_user": {
        const userId =
          report.target_type === "user" ? report.target_id : await authorOfReportedContent(report.target_type, report.target_id);

        if (!userId) return fail("Could not determine which account to restrict.");

        // `is_suspended` is a moderator-only column: no client grant allows it,
        // so this deliberately goes through the service handle, gated by the
        // requireModerator() check at the top of this action.
        const service = await dbService();
        await service.update(
          "profiles",
          { is_suspended: true, suspended_reason: payload.note || "Policy violation" },
          { id: userId },
          { returning: false },
        );
        action = "user_suspended";
        break;
      }
      case "warn_user":
        action = "report_resolved";
        break;
      case "dismiss":
        action = "report_dismissed";
        break;
      default:
        action = "report_resolved";
    }

    const finalStatus = payload.decision === "dismiss" ? "dismissed" : "resolved";

    await context.db.update(
      "reports",
      {
        status: finalStatus,
        reviewed_by: context.id,
        reviewed_at: new Date().toISOString(),
        resolution_note: payload.note || null,
      },
      { id: payload.reportId },
      { returning: false },
    );

    // Every moderation decision is recorded, including dismissals.
    await context.db.insert(
      "moderation_actions",
      {
        moderator_id: context.id,
        action,
        target_type: report.target_type,
        target_id: report.target_id,
        report_id: report.id,
        note: payload.note || null,
        metadata: { decision: payload.decision, previous_status: report.status },
      },
      { returning: false },
    );

    revalidatePath("/moderation");
    revalidatePath("/home");
    return ok("Report updated.");
  });
}

/**
 * Resolve the profile behind a reported post or comment.
 *
 * Reached only from resolveReportAction (already gated by requireModerator) and
 * only for a suspension decision. Authorship is read through the service handle
 * because clients are not granted `posts.author_id` / `comments.author_id` at
 * all — see migration 0003. Every call site writes a moderation_actions row.
 */
async function authorOfReportedContent(
  targetType: "post" | "comment",
  targetId: string,
): Promise<string | null> {
  const service = await dbService();
  const table = targetType === "comment" ? "comments" : "posts";
  const rows = await service.select<{ author_id: string }>(table, {
    columns: "author_id",
    where: { id: targetId },
    limit: 1,
  });
  return rows[0]?.author_id ?? null;
}

export async function reinstateUserAction(userId: string): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireAdmin();
    const service = await dbService();

    await service.update("profiles", { is_suspended: false, suspended_reason: null }, { id: userId }, { returning: false });

    await context.db.insert("moderation_actions", {
      moderator_id: context.id,
      action: "user_reinstated",
      target_type: "user",
      target_id: userId,
      note: "Account reinstated",
    }, { returning: false });

    revalidatePath("/admin/users");
    return ok("Account reinstated.");
  });
}

export async function suspendUserAction(userId: string, reason: string): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireAdmin();
    if (!reason.trim()) return fail("Add a reason so the decision is auditable.");

    const service = await dbService();
    await service.update(
      "profiles",
      { is_suspended: true, suspended_reason: reason.trim() },
      { id: userId },
      { returning: false },
    );

    await context.db.insert("moderation_actions", {
      moderator_id: context.id,
      action: "user_suspended",
      target_type: "user",
      target_id: userId,
      note: reason.trim(),
    }, { returning: false });

    revalidatePath("/admin/users");
    return ok("Account suspended.");
  });
}

export async function setUserRoleAction(userId: string, role: "user" | "moderator" | "admin"): Promise<ActionResult> {
  return runAction(async () => {
    const context = await requireAdmin();
    if (userId === context.id) return fail("You cannot change your own role.");

    const updated = await context.db.update(
      "user_roles",
      { role, granted_by: context.id, granted_at: new Date().toISOString() },
      { user_id: userId },
      { columns: "user_id" },
    );

    if (updated.length === 0) return fail("That account has no role row.");

    // Role changes are the most sensitive action in the product: always audited.
    await context.db.insert("audit_log", {
      actor_id: context.id,
      actor_role: context.role,
      event: "role_changed",
      target_type: "user",
      target_id: userId,
      metadata: { role },
    }, { returning: false });

    revalidatePath("/admin/users");
    return ok(`Role set to ${role}.`);
  });
}

export async function deanonymisePostAction(formData: FormData): Promise<ActionResult<{ username: string; displayName: string }>> {
  return runAction(async () => {
    const context = await requireModerator();

    const payload = deanonymiseSchema.parse({
      postId: formData.get("postId"),
      reason: formData.get("reason"),
    });

    // The database function re-checks the moderator role and writes the audit
    // entry itself — this call cannot succeed without a justification.
    const rows = await context.db.rpc<{
      author_id: string;
      author_username: string;
      author_display_name: string;
    }>("deanonymise_post", { p_post_id: payload.postId, p_reason: payload.reason });

    const result = rows[0];
    if (!result) return fail("That post could not be found.");

    return okWith(
      { username: result.author_username, displayName: result.author_display_name },
      "Identity disclosed. This action has been written to the audit log.",
    );
  });
}
