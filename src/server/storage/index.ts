import "server-only";

import { createHash } from "node:crypto";
import { existsSync, mkdirSync } from "node:fs";
import { writeFile } from "node:fs/promises";
import { join, normalize } from "node:path";

import { dataBackend, env } from "@/lib/env";

/**
 * Upload handling.
 *
 * Two backends behind one interface:
 *   • Supabase Storage — production. Files land in a bucket and the object name
 *     is `<user-uuid>/<filename>`, which is what the storage policies in
 *     migration 0004 key on, so a user can never overwrite someone else's file.
 *   • Local filesystem — development, served back through /media/*.
 *
 * Validation is applied identically in both cases and happens before anything
 * is written: an allow-list of MIME types, a magic-byte sniff, and a hard size
 * cap. Relying on the browser's `Content-Type` alone would let anyone upload a
 * script with an image header.
 */

export const BUCKETS = {
  avatars: { maxBytes: 2 * 1024 * 1024, mime: ["image/jpeg", "image/png", "image/webp", "image/gif"] },
  banners: { maxBytes: 5 * 1024 * 1024, mime: ["image/jpeg", "image/png", "image/webp"] },
  "post-media": { maxBytes: 5 * 1024 * 1024, mime: ["image/jpeg", "image/png", "image/webp", "image/gif"] },
} as const;

export type BucketName = keyof typeof BUCKETS;

export interface UploadResult {
  ok: true;
  /** Object key stored in the database, e.g. `<uuid>/<file>.webp`. */
  path: string;
  /** URL the browser should use. */
  url: string;
  width?: number;
  height?: number;
  bytes: number;
}

export interface UploadError {
  ok: false;
  error: string;
}

const EXTENSIONS: Record<string, string> = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/webp": "webp",
  "image/gif": "gif",
};

/** Magic-byte check. Trusting the declared MIME type is not enough. */
function sniffMime(bytes: Uint8Array): string | null {
  if (bytes.length < 12) return null;

  if (bytes[0] === 0xff && bytes[1] === 0xd8 && bytes[2] === 0xff) return "image/jpeg";
  if (bytes[0] === 0x89 && bytes[1] === 0x50 && bytes[2] === 0x4e && bytes[3] === 0x47) return "image/png";
  if (bytes[8] === 0x57 && bytes[9] === 0x45 && bytes[10] === 0x42 && bytes[11] === 0x50) return "image/webp";
  if (bytes[0] === 0x47 && bytes[1] === 0x49 && bytes[2] === 0x46) return "image/gif";

  return null;
}

/** Best-effort intrinsic size read (no dependency, fails soft). */
function readDimensions(bytes: Uint8Array, mime: string): { width?: number; height?: number } {
  try {
    if (mime === "image/png") {
      const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
      return { width: view.getUint32(16), height: view.getUint32(20) };
    }
    if (mime === "image/gif") {
      const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
      return { width: view.getUint16(6, true), height: view.getUint16(8, true) };
    }
  } catch {
    /* fall through */
  }
  return {};
}

export function validateUpload(bucket: BucketName, file: { size: number; arrayBuffer: () => Promise<ArrayBuffer> }) {
  const rules = BUCKETS[bucket];
  if (file.size <= 0) return { ok: false as const, error: "That file is empty." };
  if (file.size > rules.maxBytes) {
    const mb = Math.round(rules.maxBytes / 1024 / 1024);
    return { ok: false as const, error: `Images must be smaller than ${mb} MB.` };
  }
  return { ok: true as const };
}

export async function uploadImage(
  bucket: BucketName,
  userId: string,
  file: File,
): Promise<UploadResult | UploadError> {
  const rules = BUCKETS[bucket];

  const basic = validateUpload(bucket, file);
  if (!basic.ok) return basic;

  const buffer = new Uint8Array(await file.arrayBuffer());
  const sniffed = sniffMime(buffer);

  if (!sniffed || !rules.mime.includes(sniffed as never)) {
    return { ok: false, error: "Only JPEG, PNG, WebP and GIF images are supported." };
  }

  const checksum = createHash("sha256").update(buffer).digest("hex").slice(0, 16);
  const filename = `${Date.now()}-${checksum}.${EXTENSIONS[sniffed]}`;

  // Object name begins with the owner's id: the storage policies depend on it.
  const objectPath = `${userId}/${filename}`;
  const dimensions = readDimensions(buffer, sniffed);

  if (dataBackend() === "supabase") {
    const { supabaseServerClient } = await import("@/server/auth/session");
    const client = await supabaseServerClient();
    if (!client) return { ok: false, error: "Storage is not configured." };

    const { error } = await client.storage.from(bucket).upload(objectPath, buffer, {
      contentType: sniffed,
      upsert: false,
    });
    if (error) return { ok: false, error: error.message };

    const { data } = client.storage.from(bucket).getPublicUrl(objectPath);
    return { ok: true, path: objectPath, url: data.publicUrl, ...dimensions, bytes: buffer.byteLength };
  }

  // ---------------------------------------------------------------- local dev
  const root = join(process.cwd(), ".data", "uploads", bucket);
  if (!existsSync(root)) mkdirSync(root, { recursive: true });

  const target = join(root, objectPath);
  // Defence in depth against a path-traversal object name.
  if (!normalize(target).startsWith(normalize(root))) {
    return { ok: false, error: "Invalid upload path." };
  }

  await writeFile(target, buffer);

  return {
    ok: true,
    path: objectPath,
    url: `/media/${bucket}/${objectPath}`,
    ...dimensions,
    bytes: buffer.byteLength,
  };
}

/**
 * Resolve a stored media path to something the browser can load.
 * Absolute URLs (a Supabase public URL already stored) pass through untouched.
 */
export function mediaUrl(path: string | null | undefined): string | null {
  if (!path) return null;
  if (path.startsWith("http://") || path.startsWith("https://") || path.startsWith("/")) return path;
  return `${env.supabaseUrl ? "" : ""}/media/${path.replace(/^\//, "")}`;
}
