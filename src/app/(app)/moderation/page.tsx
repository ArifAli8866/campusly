import type { Metadata } from "next";
import Link from "next/link";
import { CheckCircle, EyeOff, Flag, ShieldCheck, Trash2 } from "lucide-react";

import { BRAND } from "@/components/brand";
import { Badge, Card, EmptyState } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { PageHeader } from "@/components/layout/page-header";
import { relativeTime } from "@/lib/utils";
import { getCurrentContext } from "@/server/auth/context";
import { getModerationQueue, viewerScope } from "@/server/services/queries";
import { resolveReportAction } from "@/server/actions/admin";

export const metadata: Metadata = {
  title: `Moderation Queue — ${BRAND.name}`,
  robots: { index: false, follow: false },
};

export const dynamic = "force-dynamic";

export default async function ModerationPage({
  searchParams,
}: {
  searchParams: Promise<{ status?: "pending" | "resolved" | "dismissed" }>;
}) {
  const params = await searchParams;
  const context = await getCurrentContext();
  const scope = await viewerScope();

  const isModerator = context && (context.role === "moderator" || context.role === "admin");
  const activeStatus = params.status || "pending";

  const queue = isModerator
    ? await getModerationQueue(scope, { status: activeStatus, limit: 30 })
    : [];

  return (
    <div className="mx-auto w-full max-w-4xl px-4 py-6 sm:py-8">
      <PageHeader
        title="Moderation Queue"
        description="Review community reports, take safety actions, and enforce harassment/doxxing guidelines across campuses."
      />

      {!isModerator ? (
        <Card className="mt-8 p-10 text-center">
          <EmptyState
            icon={ShieldCheck}
            title="Moderator Access Required"
            description="You do not have moderator or administrator privileges for campus communities. If you are an appointed student moderator, please contact campus support."
            action={
              <Button asChild variant="outline">
                <Link href="/home">Return to Home Feed</Link>
              </Button>
            }
          />
        </Card>
      ) : (
        <div className="mt-8 space-y-6">
          {/* Status Tabs */}
          <div className="flex items-center gap-2 border-b border-border/70 pb-3">
            {[
              { id: "pending", label: "Pending Review" },
              { id: "resolved", label: "Resolved" },
              { id: "dismissed", label: "Dismissed" },
            ].map((tab) => (
              <Link
                key={tab.id}
                href={`/moderation?status=${tab.id}`}
                className={`rounded-full px-4 py-1.5 text-xs font-medium transition-all ${
                  activeStatus === tab.id
                    ? "bg-primary text-primary-foreground shadow-2xs"
                    : "border border-border/80 bg-card text-muted-foreground hover:bg-muted hover:text-foreground"
                }`}
              >
                {tab.label}
              </Link>
            ))}
          </div>

          {/* Queue items */}
          {queue.length > 0 ? (
            <div className="space-y-4">
              {queue.map((item) => {
                const snapshot = item.target_snapshot as Record<string, string> | null;
                const contentBody = snapshot?.body || snapshot?.text || item.description || "No text snapshot";

                return (
                  <Card key={item.report_id} className="p-5 space-y-4">
                    <div className="flex flex-wrap items-center justify-between gap-2 border-b border-border/60 pb-3">
                      <div className="flex items-center gap-2">
                        <Badge variant="danger" size="sm" className="gap-1 capitalize">
                          <Flag className="size-3" /> {item.reason.replace(/_/g, " ")}
                        </Badge>
                        <Badge variant="outline" size="sm" className="capitalize">
                          {item.target_type}
                        </Badge>
                        {item.report_count > 1 ? (
                          <Badge variant="warning" size="sm">
                            {item.report_count} reports
                          </Badge>
                        ) : null}
                      </div>

                      <span className="text-xs text-muted-foreground">
                        Reported {relativeTime(item.created_at)}
                      </span>
                    </div>

                    {/* Content Preview */}
                    <div className="rounded-xl border border-border bg-muted/40 p-3.5 text-sm">
                      <p className="text-foreground leading-relaxed italic font-serif">
                        "{contentBody}"
                      </p>
                      {item.description ? (
                        <p className="mt-2 text-xs text-muted-foreground border-t border-border/50 pt-2">
                          <strong>Reporter Note:</strong> {item.description}
                        </p>
                      ) : null}
                    </div>

                    {/* Action Form */}
                    {activeStatus === "pending" ? (
                      <div className="flex flex-wrap items-center gap-2 pt-1">
                        <form action={resolveReportAction} className="inline-flex gap-2">
                          <input type="hidden" name="reportId" value={item.report_id} />
                          <input type="hidden" name="decision" value="hide_content" />
                          <Button type="submit" size="sm" variant="outline" className="gap-1.5 text-warning">
                            <EyeOff className="size-3.5" /> Hide Content
                          </Button>
                        </form>

                        <form action={resolveReportAction} className="inline-flex gap-2">
                          <input type="hidden" name="reportId" value={item.report_id} />
                          <input type="hidden" name="decision" value="remove_content" />
                          <Button type="submit" size="sm" variant="danger" className="gap-1.5">
                            <Trash2 className="size-3.5" /> Remove Content
                          </Button>
                        </form>

                        <form action={resolveReportAction} className="inline-flex gap-2">
                          <input type="hidden" name="reportId" value={item.report_id} />
                          <input type="hidden" name="decision" value="dismiss" />
                          <Button type="submit" size="sm" variant="ghost" className="gap-1.5">
                            <CheckCircle className="size-3.5" /> Dismiss
                          </Button>
                        </form>
                      </div>
                    ) : (
                      <p className="text-xs text-muted-foreground">
                        Resolved {item.reviewed_at ? relativeTime(item.reviewed_at) : ""}
                        {item.reviewed_by_username ? ` by @${item.reviewed_by_username}` : ""}
                        {item.resolution_note ? ` — Note: ${item.resolution_note}` : ""}
                      </p>
                    )}
                  </Card>
                );
              })}
            </div>
          ) : (
            <Card className="p-8 text-center">
              <EmptyState
                icon={CheckCircle}
                title="Moderation queue is clean"
                description={`There are currently no ${activeStatus} reports to review.`}
              />
            </Card>
          )}
        </div>
      )}
    </div>
  );
}
