"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

import { ICONS, type NavItem } from "@/components/layout/nav-config";
import { cn } from "@/lib/utils";

/**
 * The floating navigation dock.
 *
 * Visually it is the rounded pill from the reference design; functionally it is
 * a plain list of links with a real active state derived from the pathname, so
 * it keeps working with the keyboard, with a screen reader, and with JS off.
 */
export function HeaderNav({ items }: { items: NavItem[] }) {
  const pathname = usePathname();

  return (
    <nav aria-label="Primary" className="flex items-center gap-1 rounded-full border border-border/80 bg-card/90 p-1 shadow-[var(--shadow-pill)] backdrop-blur-xl">
      {items.map((item) => {
        const active = item.matchNested ? pathname.startsWith(item.href) : pathname === item.href;
        const Icon = ICONS[item.icon];

        return (
          <Link
            key={item.href}
            href={item.href}
            aria-current={active ? "page" : undefined}
            className={cn(
              "flex items-center gap-1.5 rounded-full px-3.5 py-1.5 text-[0.8125rem] font-medium transition-all duration-150",
              active
                ? "bg-primary text-primary-foreground shadow-xs"
                : "text-muted-foreground hover:bg-muted/80 hover:text-foreground",
            )}
          >
            <Icon className="size-3.5" aria-hidden />
            {item.label}
          </Link>
        );
      })}
    </nav>
  );
}
