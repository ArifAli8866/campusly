import { NextResponse } from "next/server";

import { getUniversityChoices, viewerScope } from "@/server/services/queries";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

/** Searchable university dropdown source. Never loads the full catalogue. */
export async function GET(request: Request) {
  const url = new URL(request.url);
  const query = url.searchParams.get("q") ?? "";
  const scope = await viewerScope();
  const universities = await getUniversityChoices(scope, query, 20);
  return NextResponse.json({ universities });
}
