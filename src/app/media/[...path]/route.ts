import { createReadStream, existsSync, statSync } from "node:fs";
import { extname, join, normalize } from "node:path";
import { Readable } from "node:stream";

import { NextResponse } from "next/server";

export const runtime = "nodejs";

const MIME: Record<string, string> = {
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".png": "image/png",
  ".webp": "image/webp",
  ".gif": "image/gif",
};

/**
 * Serves locally-uploaded media in development.
 *
 * On Supabase this route is never used: `post.media_path` holds a full
 * storage.googleapis/Supabase public URL and the browser loads it directly.
 * The path is normalised and re-joined against the upload root so a crafted
 * `../` segment cannot escape the directory.
 */
export async function GET(_request: Request, { params }: { params: Promise<{ path: string[] }> }) {
  const { path } = await params;

  const root = join(process.cwd(), ".data", "uploads");
  const target = normalize(join(root, ...path));

  if (!target.startsWith(normalize(root))) {
    return new NextResponse("Not found", { status: 404 });
  }
  if (!existsSync(target) || !statSync(target).isFile()) {
    return new NextResponse("Not found", { status: 404 });
  }

  const type = MIME[extname(target).toLowerCase()] ?? "application/octet-stream";
  const stream = Readable.toWeb(createReadStream(target)) as ReadableStream;

  return new NextResponse(stream, {
    headers: {
      "Content-Type": type,
      "Cache-Control": "public, max-age=31536000, immutable",
      "X-Content-Type-Options": "nosniff",
    },
  });
}
