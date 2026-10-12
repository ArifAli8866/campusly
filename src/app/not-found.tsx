import Link from "next/link";
import { Compass, SearchX } from "lucide-react";

import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/primitives";

export const metadata = { title: "Page not found" };

export default function NotFound() {
  return (
    <div className="mx-auto flex min-h-[70dvh] w-full max-w-lg flex-col items-center justify-center px-4">
      <EmptyState
        icon={SearchX}
        title="We could not find that page"
        description="The link may be old, or the university, channel or post may have been removed."
        action={
          <div className="flex flex-wrap justify-center gap-2">
            <Button asChild>
              <Link href="/universities">
                <Compass /> Browse universities
              </Link>
            </Button>
            <Button asChild variant="outline">
              <Link href="/">Go home</Link>
            </Button>
          </div>
        }
      />
    </div>
  );
}
