"use client";

import Link from "next/link";
import { useEffect } from "react";
import { RotateCcw, TriangleAlert } from "lucide-react";

import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/primitives";

export default function GlobalError({ error, reset }: { error: Error & { digest?: string }; reset: () => void }) {
  useEffect(() => {
    // Client-side logging only; the server already logged the real cause.
    console.error("[campusly] render error", error.digest ?? error.message);
  }, [error]);

  return (
    <div className="mx-auto flex min-h-[70dvh] w-full max-w-lg flex-col items-center justify-center px-4">
      <EmptyState
        icon={TriangleAlert}
        title="Something went wrong on our side"
        description="This is not your fault, and nothing you posted was lost. Try again — if it keeps happening, the error reference is below."
        action={
          <div className="flex flex-wrap justify-center gap-2">
            <Button onClick={reset}>
              <RotateCcw /> Try again
            </Button>
            <Button asChild variant="outline">
              <Link href="/">Go home</Link>
            </Button>
          </div>
        }
      />
      {error.digest ? (
        <p className="mt-4 text-xs text-muted-foreground">
          Reference: <code className="rounded bg-muted px-1.5 py-0.5">{error.digest}</code>
        </p>
      ) : null}
    </div>
  );
}
