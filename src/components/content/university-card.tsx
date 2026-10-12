import Link from "next/link";
import { Building2, MapPin, MessageSquare, Users } from "lucide-react";

import { JoinButton } from "@/components/content/join-button";
import { Badge } from "@/components/ui/primitives";
import type { UniversityCard as UniversityCardData } from "@/lib/db/types";
import { cn, compactNumber, pluralize } from "@/lib/utils";

/**
 * University card for the discovery grid.
 *
 * Branding: we never fabricate an official university logo. When an institution
 * has no `logo_url` we render a neutral monogram derived from its abbreviation,
 * which is clearly a placeholder and trivially replaceable from /admin.
 */
export function UniversityCard({
  university,
  signedIn,
  className,
  priority = false,
}: {
  university: UniversityCardData;
  signedIn: boolean;
  className?: string;
  priority?: boolean;
}) {
  const primaryCampus = university.campuses.find((campus) => campus.member_count > 0) ?? university.campuses[0];
  const monogram = (university.abbreviation ?? university.name)
    .replace(/[^A-Za-z]/g, "")
    .slice(0, 3)
    .toUpperCase();

  return (
    <article className={cn("surface group flex flex-col overflow-hidden", className)}>
      {/* banner */}
      <Link
        href={`/universities/${university.slug}`}
        className="relative block h-24 overflow-hidden bg-ink-950"
        aria-label={`${university.name} — open university page`}
      >
        {university.banner_url ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={university.banner_url}
            alt=""
            loading={priority ? "eager" : "lazy"}
            className="size-full object-cover transition-transform duration-500 group-hover:scale-[1.03]"
          />
        ) : (
          <span className="grid-canvas absolute inset-0 opacity-20" aria-hidden />
        )}
        <span className="absolute inset-0 bg-gradient-to-t from-ink-950/70 to-transparent" aria-hidden />

        {university.is_featured ? (
          <Badge variant="accent" size="sm" className="absolute right-3 top-3">
            Featured
          </Badge>
        ) : null}
      </Link>

      <div className="flex flex-1 flex-col p-5 pt-0">
        {/* logo / monogram */}
        <div className="-mt-7 mb-3 flex items-end justify-between gap-3">
          <span className="flex size-14 items-center justify-center overflow-hidden rounded-2xl border-4 border-card bg-card shadow-[var(--shadow-soft)]">
            {university.logo_url ? (
              // eslint-disable-next-line @next/next/no-img-element
              <img src={university.logo_url} alt={`${university.name} logo`} className="size-full object-contain p-1" />
            ) : (
              <span
                className="flex size-full items-center justify-center rounded-xl bg-muted text-sm font-semibold tracking-tight text-foreground"
                aria-hidden
              >
                {monogram}
              </span>
            )}
          </span>

          <JoinButton
            channelId={primaryCampus?.id ?? null}
            channelSlug={primaryCampus?.slug ?? null}
            isMember={university.viewer_is_member}
            signedIn={signedIn}
            size="sm"
          />
        </div>

        <h3 className="text-[0.9375rem] font-semibold leading-snug">
          <Link href={`/universities/${university.slug}`} className="hover:underline">
            {university.name}
          </Link>
        </h3>

        <div className="mt-1 flex flex-wrap items-center gap-x-2 gap-y-0.5 text-xs text-muted-foreground">
          {university.abbreviation ? <span className="font-medium">{university.abbreviation}</span> : null}
          {university.city ? (
            <span className="inline-flex items-center gap-1">
              <MapPin className="size-3" aria-hidden />
              {university.city}
            </span>
          ) : null}
          {university.campus_count > 1 ? (
            <span className="inline-flex items-center gap-1">
              <Building2 className="size-3" aria-hidden />
              {university.campus_count} campuses
            </span>
          ) : null}
        </div>

        {university.description ? (
          <p className="mt-2.5 line-clamp-2 text-[0.8125rem] leading-relaxed text-muted-foreground">
            {university.description.replace(/^[^.]+\.\s*/, "")}
          </p>
        ) : null}

        <dl className="mt-auto grid grid-cols-2 gap-3 border-t border-border pt-3.5 text-xs">
          <div>
            <dt className="flex items-center gap-1 text-muted-foreground">
              <Users className="size-3" aria-hidden /> Members
            </dt>
            <dd className="mt-0.5 text-[0.9375rem] font-semibold tabular-nums">
              {compactNumber(university.member_count)}
            </dd>
          </div>
          <div>
            <dt className="flex items-center gap-1 text-muted-foreground">
              <MessageSquare className="size-3" aria-hidden /> Posts
            </dt>
            <dd className="mt-0.5 text-[0.9375rem] font-semibold tabular-nums">
              {compactNumber(university.post_count)}
            </dd>
          </div>
        </dl>

        {university.campuses.length > 1 ? (
          <ul className="mt-3 flex flex-wrap gap-1">
            {university.campuses.slice(0, 3).map((campus) => (
              <li key={campus.id}>
                <Link
                  href={`/channels/${campus.slug}`}
                  className="inline-flex rounded-full border border-border px-2 py-0.5 text-[0.6875rem] text-muted-foreground transition-colors hover:border-border-strong hover:text-foreground"
                >
                  {campus.name.replace(/ Campus$/, "")}
                  {campus.member_count > 0 ? ` · ${compactNumber(campus.member_count)}` : ""}
                </Link>
              </li>
            ))}
            {university.campuses.length > 3 ? (
              <li className="inline-flex items-center rounded-full px-2 py-0.5 text-[0.6875rem] text-muted-foreground">
                +{university.campuses.length - 3} more{" "}
                {pluralize(university.campuses.length - 3, "campus")}
              </li>
            ) : null}
          </ul>
        ) : primaryCampus ? (
          <Link
            href={`/channels/${primaryCampus.slug}`}
            className="mt-3 inline-flex text-xs font-medium text-accent hover:underline"
          >
            Open the {primaryCampus.name.replace(/ Campus$/, "")} community →
          </Link>
        ) : null}
      </div>
    </article>
  );
}
