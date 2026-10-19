"use client";

import Link from "next/link";
import { useEffect } from "react";
import { RotateCcw, TriangleAlert } from "lucide-react";

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error("[campusly] critical global error", error.digest ?? error.message);
  }, [error]);

  return (
    <html lang="en">
      <body className="min-h-dvh bg-[#0b0b0d] text-[#f7f7f8] antialiased flex items-center justify-center p-4">
        <main className="w-full max-w-md text-center space-y-4">
          <div className="mx-auto flex size-12 items-center justify-center rounded-full bg-red-500/10 text-red-400">
            <TriangleAlert className="size-6" />
          </div>
          <h1 className="text-xl font-bold tracking-tight">Application Error</h1>
          <p className="text-sm text-zinc-400">
            A critical error occurred while rendering the page. You can try refreshing or resetting the application state.
          </p>
          {error.digest ? (
            <p className="text-xs text-zinc-500">
              Digest: <code className="rounded bg-zinc-800 px-1.5 py-0.5">{error.digest}</code>
            </p>
          ) : null}
          <div className="pt-2 flex justify-center gap-3">
            <button
              type="button"
              onClick={reset}
              className="inline-flex items-center gap-2 rounded-full bg-white px-5 py-2 text-sm font-semibold text-black hover:bg-zinc-200 transition-colors"
            >
              <RotateCcw className="size-4" /> Try again
            </button>
            <Link
              href="/"
              className="inline-flex items-center gap-2 rounded-full border border-zinc-700 px-5 py-2 text-sm font-semibold text-zinc-300 hover:bg-zinc-800 transition-colors"
            >
              Go home
            </Link>
          </div>
        </main>
      </body>
    </html>
  );
}
