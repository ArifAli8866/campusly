import { NextResponse } from "next/server";

import { createServerClient } from "@supabase/ssr";

import { dataBackend, env } from "@/lib/env";

export const runtime = "nodejs";

/**
 * OAuth / email-confirmation callback.
 *
 * Supabase redirects here with a `code`; we exchange it for a session, which
 * @supabase/ssr then writes into httpOnly cookies. `next` is validated to be a
 * same-origin path so the callback cannot be used as an open redirect.
 */
export async function GET(request: Request) {
  const url = new URL(request.url);
  const code = url.searchParams.get("code");
  const requested = url.searchParams.get("next") ?? "/home";
  const next = requested.startsWith("/") && !requested.startsWith("//") ? requested : "/home";

  if (dataBackend() !== "supabase") {
    return NextResponse.redirect(new URL("/login?error=oauth-not-configured", url.origin));
  }

  if (!code) {
    // Supabase reports provider errors in these params.
    const providerError = url.searchParams.get("error_description") ?? url.searchParams.get("error");
    return NextResponse.redirect(
      new URL(`/login?error=${encodeURIComponent(providerError ?? "missing-code")}`, url.origin),
    );
  }

  const response = NextResponse.redirect(new URL(next, url.origin));

  const client = createServerClient(env.supabaseUrl!, env.supabaseAnonKey!, {
    cookies: {
      getAll: () => [],
      setAll: (cookiesToSet) => {
        for (const { name, value, options } of cookiesToSet) {
          response.cookies.set(name, value, options);
        }
      },
    },
  });

  const { error } = await client.auth.exchangeCodeForSession(code);
  if (error) {
    return NextResponse.redirect(new URL(`/login?error=${encodeURIComponent(error.message)}`, url.origin));
  }

  return response;
}
