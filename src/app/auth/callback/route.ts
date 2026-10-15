import { cookies } from "next/headers";
import { NextResponse } from "next/server";

import { createServerClient } from "@supabase/ssr";
import type { EmailOtpType } from "@supabase/supabase-js";

import { dataBackend, env } from "@/lib/env";

export const runtime = "nodejs";

/**
 * OAuth / email-confirmation callback.
 *
 * Supabase redirects here with a `code` (or `token_hash`); we exchange it for
 * a session, which @supabase/ssr then writes into httpOnly cookies.
 * `next` is validated to be a same-origin path so the callback cannot be used as
 * an open redirect.
 */
export async function GET(request: Request) {
  const url = new URL(request.url);
  const code = url.searchParams.get("code");
  const token_hash = url.searchParams.get("token_hash");
  const type = url.searchParams.get("type") as EmailOtpType | null;
  const requested = url.searchParams.get("next") ?? "/home";
  const next = requested.startsWith("/") && !requested.startsWith("//") ? requested : "/home";

  const forwardedHost = request.headers.get("x-forwarded-host");
  const isLocalEnv = process.env.NODE_ENV === "development";
  const origin = isLocalEnv
    ? url.origin
    : forwardedHost
      ? `https://${forwardedHost}`
      : (env.siteUrl || url.origin);

  if (dataBackend() !== "supabase") {
    return NextResponse.redirect(new URL("/login?error=oauth-not-configured", origin));
  }

  // Supabase reports provider errors in these params.
  const providerError = url.searchParams.get("error_description") ?? url.searchParams.get("error");
  if (providerError) {
    return NextResponse.redirect(
      new URL(`/login?error=${encodeURIComponent(providerError)}`, origin),
    );
  }

  const cookieStore = await cookies();
  const response = NextResponse.redirect(new URL(next, origin));

  const client = createServerClient(env.supabaseUrl!, env.supabaseAnonKey!, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        for (const { name, value, options } of cookiesToSet) {
          try {
            cookieStore.set(name, value, options);
          } catch {
            // Ignored if called during response streaming
          }
          response.cookies.set(name, value, options);
        }
      },
    },
  });

  if (code) {
    const { error } = await client.auth.exchangeCodeForSession(code);
    if (error) {
      return NextResponse.redirect(new URL(`/login?error=${encodeURIComponent(error.message)}`, origin));
    }
    return response;
  }

  if (token_hash && type) {
    const { error } = await client.auth.verifyOtp({ type, token_hash });
    if (error) {
      return NextResponse.redirect(new URL(`/login?error=${encodeURIComponent(error.message)}`, origin));
    }
    return response;
  }

  return NextResponse.redirect(new URL("/login?error=missing-code", origin));
}

