import { cn } from "@/lib/utils";

/**
 * Brand mark + wordmark.
 *
 * The product name is a working title: change `BRAND` in one place and the
 * whole app (header, footer, metadata, manifest, emails) follows. The mark is
 * an inline SVG so it inherits currentColor, needs no network request, and
 * renders in the sandboxed preview.
 */
export const BRAND = {
  name: "Campusly",
  tagline: "Your campus. Your stories. Your voice.",
  domain: "campusly.pk",
} as const;

export function LogoMark({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 32 32" fill="none" className={cn("size-7", className)} aria-hidden focusable="false">
      <rect width="32" height="32" rx="9" fill="currentColor" />
      <path
        d="M9.5 13.2 16 9.6l6.5 3.6L16 16.8 9.5 13.2Z"
        fill="var(--card)"
        stroke="var(--card)"
        strokeWidth="1.4"
        strokeLinejoin="round"
      />
      <path
        d="M12.4 16.4v4.1c0 1.5 1.9 2.6 3.6 2.6s3.6-1.1 3.6-2.6v-4.1"
        stroke="var(--card)"
        strokeWidth="1.6"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <circle cx="22.6" cy="16.6" r="1.15" fill="var(--card)" />
    </svg>
  );
}

export function BrandLockup({
  className,
  markClassName,
  showName = true,
}: {
  className?: string;
  markClassName?: string;
  showName?: boolean;
}) {
  return (
    <span className={cn("inline-flex items-center gap-2 text-ink-950 dark:text-ink-50", className)}>
      <LogoMark className={markClassName} />
      {showName ? (
        <span className="text-[0.9375rem] font-semibold tracking-[-0.02em]">{BRAND.name}</span>
      ) : null}
    </span>
  );
}
