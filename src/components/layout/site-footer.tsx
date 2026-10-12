import Link from "next/link";
import { ShieldCheck } from "lucide-react";

import { BRAND, BrandLockup } from "@/components/brand";
import { ThemeToggle } from "@/components/ui/theme-toggle";
import { FOOTER_NAV } from "@/components/layout/nav-config";

/**
 * Footer.
 *
 * Every link here resolves to a page that exists in this app — there are no
 * decorative href="#" anchors anywhere in the shell.
 */
export function SiteFooter() {
  return (
    <footer className="mt-20 border-t border-border bg-surface">
      <div className="mx-auto grid w-full max-w-6xl gap-10 px-4 py-14 sm:grid-cols-2 lg:grid-cols-5">
        <div className="lg:col-span-2">
          <BrandLockup />
          <p className="mt-3 max-w-xs text-sm leading-relaxed text-muted-foreground">
            A student community for every university campus in Pakistan. Read freely, post anonymously when you want
            to, and keep your identity yours.
          </p>
          <div className="mt-5 flex items-center gap-3">
            <ThemeToggle />
            <span className="text-xs text-muted-foreground">Theme</span>
          </div>
        </div>

        {FOOTER_NAV.map((group) => (
          <nav key={group.title} aria-label={group.title}>
            <h2 className="text-[0.8125rem] font-semibold">{group.title}</h2>
            <ul className="mt-3 space-y-2.5">
              {group.links.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-muted-foreground transition-colors hover:text-foreground"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </nav>
        ))}
      </div>

      <div className="border-t border-border">
        <div className="mx-auto flex w-full max-w-6xl flex-wrap items-center justify-between gap-3 px-4 py-5 text-xs text-muted-foreground">
          <p>
            © {new Date().getFullYear()} {BRAND.name}. Built for students, run by students.
          </p>
          <p className="flex items-center gap-1.5">
            <ShieldCheck className="size-3.5" aria-hidden />
            Anonymity is enforced in the database, not just in the interface.
          </p>
        </div>
      </div>
    </footer>
  );
}
