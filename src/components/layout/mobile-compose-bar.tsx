"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Bookmark, Compass, Home, Layers, PenLine } from "lucide-react";

import { BRAND } from "@/components/brand";
import { cn } from "@/lib/utils";

const TABS = [
  { href: "/home", label: "Home", icon: Home },
  { href: "/explore", label: "Explore", icon: Compass },
  { href: "/joined", label: "Joined", icon: Layers },
  { href: "/saved", label: "Saved", icon: Bookmark },
] as const;

/**
 * Fixed bottom bar for touch devices.
 *
 * It replaces a floating hamburger: four destinations are one tap away and the
 * centre action opens the composer. Nothing here is decorative — every control
 * lands on a real route, and the compose action is disabled with an explanation
 * when the student has not joined a community yet.
 */
export function MobileComposeBar({ hasChannels }: { hasChannels: boolean }) {
  const pathname = usePathname();

  return (
    <nav
      aria-label="Mobile navigation"
      className="fixed inset-x-0 bottom-0 z-40 border-t border-border bg-card/95 pb-[env(safe-area-inset-bottom)] backdrop-blur md:hidden"
    >
      <ul className="mx-auto flex max-w-md items-stretch justify-between px-2">
        {TABS.slice(0, 2).map((tab) => (
          <BarLink key={tab.href} {...tab} active={pathname.startsWith(tab.href)} />
        ))}

        <li className="flex items-center px-1">
          {hasChannels ? (
            <Link
              href="/compose"
              aria-label="Write a confession"
              className="flex size-11 -translate-y-3 items-center justify-center rounded-full bg-primary text-primary-foreground shadow-[var(--shadow-lift)]"
            >
              <PenLine className="size-5" />
            </Link>
          ) : (
            <Link
              href="/explore"
              aria-label="Join a community before posting"
              title="Join a community before posting"
              className="flex size-11 -translate-y-3 items-center justify-center rounded-full border border-border bg-muted text-muted-foreground"
            >
              <PenLine className="size-5" />
            </Link>
          )}
        </li>

        {TABS.slice(2).map((tab) => (
          <BarLink key={tab.href} {...tab} active={pathname.startsWith(tab.href)} />
        ))}
      </ul>
    </nav>
  );
}

function BarLink({
  href,
  label,
  icon: Icon,
  active,
}: {
  href: string;
  label: string;
  icon: typeof Home;
  active: boolean;
}) {
  return (
    <li className="flex-1">
      <Link
        href={href}
        aria-current={active ? "page" : undefined}
        className={cn(
          "flex flex-col items-center gap-0.5 py-2.5 text-[0.625rem] font-medium transition-colors",
          active ? "text-foreground" : "text-muted-foreground",
        )}
      >
        <Icon className="size-[1.125rem]" aria-hidden />
        {label}
      </Link>
    </li>
  );
}

export { BRAND };
