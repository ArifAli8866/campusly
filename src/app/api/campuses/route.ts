import { NextResponse } from "next/server";

import { getCampusChoices, viewerScope } from "@/server/services/queries";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/** Campus dropdown for a given university. */
export async function GET(request: Request) {
  const url = new URL(request.url);
  const universityId = url.searchParams.get("universityId") ?? "";

  if (!UUID.test(universityId)) {
    return NextResponse.json({ error: "A valid universityId is required." }, { status: 400 });
  }

  const scope = await viewerScope();
  const campuses = await getCampusChoices(scope, universityId, url.searchParams.get("q") ?? undefined);
  return NextResponse.json({ campuses });
}
