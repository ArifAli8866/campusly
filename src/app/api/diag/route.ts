import { NextResponse } from "next/server";

import { dbAs } from "@/lib/db";

export const dynamic = "force-dynamic";

export async function GET() {
  const steps: Record<string, unknown> = {};
  try {
    const db = await dbAs(null);
    steps.db = "ok";
    const counts = await db.rpc<{ catalogue_counts: Record<string, number> }>("catalogue_counts");
    steps.counts = counts[0]?.catalogue_counts ?? null;
    const feed = await db.rpc<{ id: string }>("feed_posts", { p_limit: 2 });
    steps.feed = feed.length;
    steps.status = "ok";
  } catch (error) {
    steps.status = "error";
    steps.error = String((error as Error)?.message ?? error).slice(0, 300);
  }
  return NextResponse.json(steps, { status: steps.status === "ok" ? 200 : 503 });
}
