"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useState } from "react";
import { Menu, ShieldCheck, X } from "lucide-react";

import { ICONS, type NavItem } from "@/components/layout/nav-config";
import { Avatar } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogTrigger } from "@/components/ui/overlays";
import { cn } from "@/lib/utils";

/** Full-height mobile navigation sheet. Every entry points at a real route. */
export function MobileMenu({
  signedIn,
  navItems,
  accountItems,
  user,
}: {
  signedIn: boolean;
  navItems: NavItem[];
  accountItems: NavItem[];
  user: { displayName: string; username: string; avatarUrl: string | null } | null;
}) {
  const [open, setOpen] = useState(false);
  const pathname = usePathname();
  const items = [...navItems, ...accountItems];

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button variant="ghost" size="icon" className="md:hidden" aria-label="Open menu">
          <Menu />
        </Button>
      </DialogTrigger>

      <DialogContent
        title="Navigation"
        side="right"
        className="h-full w-[19rem] max-w-[85vw] rounded-none border-y-0 border-r-0 p-0"
      >
        <div className="flex h-full flex-col">
          <div className="flex items-center justify-between border-b border-border px-4 py-3.5">
            {user ? (
              <Link href={`/u/${user.username}`} onClick={() => setOpen(false)} className="flex min-w-0 items-center gap-2.5">
                <Avatar src={user.avatarUrl} name={user.displayName} size="sm" />
                <span className="min-w-0">
                  <span className="block truncate text-[0.8125rem] font-medium">{user.displayName}</span>
                  <span className="block truncate text-xs text-muted-foreground">@{user.username}</span>
                </span>
              </Link>
            ) : (
              <span className="text-[0.8125rem] font-medium">Menu</span>
            )}
            <Button variant="ghost" size="icon" onClick={() => setOpen(false)} aria-label="Close menu">
              <X />
            </Button>
          </div>

          <nav aria-label="Mobile" className="flex-1 overflow-y-auto p-2">
            <ul className="space-y-0.5">
              {items.map((item) => {
                const active = item.matchNested ? pathname.startsWith(item.href) : pathname === item.href;
                const Icon = ICONS[item.icon];
                return (
                  <li key={item.href}>
                    <Link
                      href={item.href}
                      onClick={() => setOpen(false)}
                      aria-current={active ? "page" : undefined}
                      className={cn(
                        "flex items-center gap-2.5 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors",
                        active ? "bg-muted text-foreground" : "text-muted-foreground hover:bg-muted hover:text-foreground",
                      )}
                    >
                      <Icon className="size-4" aria-hidden />
                      {item.label}
                    </Link>
                  </li>
                );
              })}
            </ul>

            <div className="mt-2 border-t border-border pt-2">
              <Link
                href="/community-guidelines"
                onClick={() => setOpen(false)}
                className="flex items-center gap-2.5 rounded-lg px-3 py-2.5 text-sm font-medium text-muted-foreground hover:bg-muted hover:text-foreground"
              >
                <ShieldCheck className="size-4" aria-hidden />
                Community guidelines
              </Link>
            </div>
          </nav>

          {!signedIn ? (
            <div className="grid gap-2 border-t border-border p-3">
              <Button asChild variant="outline">
                <Link href="/login" onClick={() => setOpen(false)}>
                  Log in
                </Link>
              </Button>
              <Button asChild>
                <Link href="/signup" onClick={() => setOpen(false)}>
                  Create an account
                </Link>
              </Button>
            </div>
          ) : null}
        </div>
      </DialogContent>
    </Dialog>
  );
}
