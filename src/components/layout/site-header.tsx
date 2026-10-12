import Link from "next/link";
import { Bell, LogIn, PenLine, Search } from "lucide-react";

import { BRAND, LogoMark } from "@/components/brand";
import { HeaderNav } from "@/components/layout/header-nav";
import { MobileMenu } from "@/components/layout/mobile-menu";
import { AccountMenu } from "@/components/layout/account-menu";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/primitives";
import { APP_NAV, ACCOUNT_NAV, PUBLIC_NAV } from "@/components/layout/nav-config";
import { getCurrentContext } from "@/server/auth/context";

/**
 * One header for both shells.
 *
 * Signed out it is the marketing header (Explore / Discover / How it works).
 * Signed in the same floating dock becomes the app navigation, and the right
 * side gains a real notification count read from the database — never a fake
 * badge or a hardcoded number.
 */
export async function SiteHeader({ variant }: { variant: "site" | "app" }) {
  const context = await getCurrentContext();
  const signedIn = Boolean(context);
  const items = signedIn && variant === "app" ? APP_NAV : PUBLIC_NAV;

  return (
    <header className="sticky top-0 z-40 border-b border-border/60 bg-background/80 backdrop-blur-xl transition-all duration-200">
      <div className="mx-auto flex h-14 w-full max-w-6xl items-center gap-3 px-4">
        <Link href={signedIn ? "/home" : "/"} className="flex items-center gap-2" aria-label={`${BRAND.name} home`}>
          <LogoMark className="size-7" />
          <span className="text-[0.9375rem] font-semibold tracking-[-0.02em]">{BRAND.name}</span>
        </Link>

        {/* centred dock — the primary navigation from the reference design */}
        <div className="pointer-events-none absolute inset-x-0 hidden justify-center md:flex">
          <div className="pointer-events-auto">
            <HeaderNav items={items} />
          </div>
        </div>

        <div className="ml-auto flex items-center gap-1.5">
          {signedIn ? (
            <>
              <Button asChild variant="ghost" size="icon" aria-label="Search">
                <Link href="/search">
                  <Search />
                </Link>
              </Button>

              <Button asChild variant="ghost" size="icon" className="relative" aria-label="Notifications">
                <Link href="/notifications">
                  <Bell />
                  {context!.unreadCount > 0 ? (
                    <Badge
                      variant="accent"
                      size="sm"
                      className="absolute -right-0.5 -top-0.5 min-w-4 justify-center px-1 tabular-nums"
                      aria-label={`${context!.unreadCount} unread notifications`}
                    >
                      {context!.unreadCount > 99 ? "99+" : context!.unreadCount}
                    </Badge>
                  ) : null}
                </Link>
              </Button>

              <Button asChild size="sm" className="hidden md:inline-flex">
                <Link href="/compose">
                  <PenLine />
                  Confess
                </Link>
              </Button>

              <AccountMenu
                user={{
                  displayName: context!.profile.displayName,
                  username: context!.profile.username,
                  avatarUrl: context!.profile.avatarUrl,
                  role: context!.role,
                }}
              />
            </>
          ) : (
            <>
              <Button asChild variant="ghost" size="sm" className="hidden sm:inline-flex">
                <Link href="/login">
                  <LogIn />
                  Log in
                </Link>
              </Button>
              <Button asChild size="sm">
                <Link href="/signup">Join free</Link>
              </Button>
            </>
          )}

          <MobileMenu
            signedIn={signedIn}
            navItems={items}
            accountItems={ACCOUNT_NAV}
            user={
              signedIn
                ? {
                    displayName: context!.profile.displayName,
                    username: context!.profile.username,
                    avatarUrl: context!.profile.avatarUrl,
                  }
                : null
            }
          />
        </div>
      </div>
    </header>
  );
}
