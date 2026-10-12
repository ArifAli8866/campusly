import "server-only";

import { randomBytes, scrypt as scryptCb } from "node:crypto";
import { promisify } from "node:util";

import { createLocalDb } from "@/lib/db/local-db";

const scrypt = promisify(scryptCb) as (password: string, salt: Buffer, keylen: number) => Promise<Buffer>;

/**
 * Local-only password storage.
 *
 * This exists purely so the app is fully usable without a Supabase project.
 * In production, Supabase Auth owns credentials and nothing in this codebase
 * ever touches them — see updatePasswordAction().
 */
export async function updateLocalPassword(userId: string, password: string): Promise<void> {
  const salt = randomBytes(16);
  const derived = await scrypt(password, salt, 64);
  const hash = `scrypt$${salt.toString("hex")}$${derived.toString("hex")}`;

  const db = createLocalDb({ actorId: null, serviceRole: true });
  await db.update("auth.users", { encrypted_password: hash }, { id: userId }, { returning: false });
}
