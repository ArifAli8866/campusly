import { NextResponse } from "next/server";

import { getSessionUser } from "@/server/auth/session";
import { dbAs } from "@/lib/db";
import { withinRateLimit } from "@/server/lib/rate-limit";
import { BUCKETS, uploadImage, type BucketName } from "@/server/storage";

export const runtime = "nodejs";

/**
 * Media upload endpoint.
 *
 * Authorisation happens before any bytes are stored: the session must exist,
 * the bucket must be one of the three user-writable ones (branding is
 * admin-only and intentionally absent here), and per-user rate limiting is
 * enforced against the database.
 */
export async function POST(request: Request) {
  const session = await getSessionUser();
  if (!session) {
    return NextResponse.json({ error: "Sign in to upload images." }, { status: 401 });
  }

  const formData = await request.formData();
  const bucket = String(formData.get("bucket") ?? "post-media") as BucketName;
  const file = formData.get("file");

  if (!(bucket in BUCKETS)) {
    return NextResponse.json({ error: "Unknown upload destination." }, { status: 400 });
  }
  if (!(file instanceof File)) {
    return NextResponse.json({ error: "No file was provided." }, { status: 400 });
  }

  const db = await dbAs(session.id);
  const allowed = await withinRateLimit(db, `upload:${bucket}`, {
    max: 30,
    windowSeconds: 3600,
    label: "Too many uploads.",
  });
  if (!allowed) {
    return NextResponse.json({ error: "You have uploaded a lot recently. Try again later." }, { status: 429 });
  }

  const result = await uploadImage(bucket, session.id, file);
  if (!result.ok) {
    return NextResponse.json({ error: result.error }, { status: 400 });
  }

  return NextResponse.json({
    path: result.url,
    objectPath: result.path,
    width: result.width ?? null,
    height: result.height ?? null,
  });
}
