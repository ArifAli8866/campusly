import type { Metadata } from "next";
import Link from "next/link";
import {
  ArrowRight,
  AtSign,
  Building2,
  EyeOff,
  Filter,
  Flag,
  GraduationCap,
  Lock,
  MessageSquare,
  Search,
  ShieldCheck,
} from "lucide-react";

import { BrandLockup } from "@/components/brand";
import { PostCard } from "@/components/content/post-card";
import { UniversityCard } from "@/components/content/university-card";
import { Avatar, Badge, Card, EmptyState } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { BRAND } from "@/components/brand";
import { getSessionUser } from "@/server/auth/session";
import {
  getCatalogueCounts,
  getTrendingTopics,
  getUniversityCards,
  getWeeklyHighlights,
  viewerScope,
} from "@/server/services/queries";
import { compactNumber } from "@/lib/utils";

export const metadata: Metadata = {
  title: `${BRAND.name} — Your campus. Your stories. Your voice.`,
  description:
    "Join your university community, share what is on your mind, and discover the stories students are talking about. Confession and discussion communities for campuses across Pakistan.",
  alternates: { canonical: "/" },
};

// Catalogue counts change rarely; a short revalidate keeps the landing page
// fast without ever showing an invented number.
export const revalidate = 120;

const HOW_IT_WORKS = [
  {
    icon: GraduationCap,
    title: "Join your campus",
    body: "Find your university, pick your campus, and join the community your classmates actually use.",
  },
  {
    icon: EyeOff,
    title: "Post anonymously or openly",
    body: "One tap decides whether your post carries your profile or a neutral Anonymous label.",
  },
  {
    icon: MessageSquare,
    title: "Talk it out",
    body: "Like, comment, reply and mention classmates. Trending surfaces what the campus is discussing.",
  },
  {
    icon: ShieldCheck,
    title: "Moderated by students",
    body: "Reports go to a human moderation queue. Reasons are recorded, actions are auditable.",
  },
];

const PLATFORM_FEATURES = [
  { icon: Search, title: "Search everything", body: "Universities, campuses, students and posts — one query, database-backed." },
  { icon: AtSign, title: "Mentions & replies", body: "Type @ to mention a classmate. Mentions resolve to real profiles, not text." },
  { icon: Filter, title: "Real trending", body: "Ranked by engagement and recency from actual votes — never a hardcoded list." },
  { icon: Building2, title: "Campus-level channels", body: "Every campus gets its own feed, so Islamabad never drowns out Peshawar." },
  { icon: Lock, title: "Privacy by design", body: "Anonymous authorship is enforced by the database, not hidden in the interface." },
  { icon: Flag, title: "Safety built in", body: "Report, block, mute, appeals — moderation is part of the architecture." },
];

const FAQS = [
  {
    q: "Is an anonymous confession really anonymous?",
    a: "To other students, yes. Your name, username, photo and profile are not stored on the visible post and are never sent to anyone else's browser. Your account is recorded privately so the platform can act on threats, doxxing and abuse — that is a legal and safety requirement, and it is disclosed in our privacy policy.",
  },
  {
    q: "Do I need a university email address?",
    a: "No. You can join with any email address. University email verification is optional and can be enabled per community later.",
  },
  {
    q: "Can I join more than one university community?",
    a: "Yes. Your profile lists one home university, but you can join as many campus communities as you like — useful if you have friends at other campuses.",
  },
  {
    q: "What happens when someone posts something harmful?",
    a: "Any student can report a post, comment or profile. It enters a moderation queue where a trained moderator reviews it, can hide or remove the content, and can restrict the account. Every action is recorded.",
  },
  {
    q: "Who runs Campusly?",
    a: "Campusly is an independent student platform. It is not affiliated with, or endorsed by, any university. Communities are created and moderated by students.",
  },
  {
    q: "Does it cost anything?",
    a: "No. Joining, posting, commenting and joining communities are free. We do not sell personal data.",
  },
];


export default async function LandingPage() {
  const scope = await viewerScope();
  const session = await getSessionUser();

  const [universities, highlights, featured, catalogue] = await Promise.all([
    getUniversityCards(scope, { sort: "most_joined", limit: 6 }),
    getWeeklyHighlights(scope, 3),
    getTrendingTopics(scope, { limit: 8, days: 30 }),
    getCatalogueCounts(scope),
  ]);

  return (
    <>
      {/* ============================================================ hero */}
      <section className="relative overflow-hidden">
        <div className="grid-canvas pointer-events-none absolute inset-0 opacity-40 [mask-image:radial-gradient(ellipse_at_top,black,transparent_72%)]" />

        <div className="relative mx-auto max-w-6xl px-4 pb-10 pt-14 sm:px-6 sm:pt-20">
          <div className="mx-auto max-w-3xl text-center">
            <Badge variant="outline" size="lg" className="mx-auto rounded-full px-4 py-1.5 shadow-xs border-border/80 bg-card/80 backdrop-blur-sm gap-2">
              <span className="size-2 rounded-full bg-emerald-500 animate-pulse" />
              <span className="text-muted-foreground text-xs font-medium">Live now</span>
              <span className="text-border">|</span>
              <span className="text-foreground text-xs font-semibold">Campuses across Pakistan</span>
            </Badge>

            <h1 className="text-display mt-5 text-foreground">
              Your campus. Your stories.
              <span className="block text-accent">Your voice.</span>
            </h1>

            <p className="mx-auto mt-5 max-w-xl text-[1.0625rem] leading-relaxed text-muted-foreground">
              Join your university community, share what is on your mind, and discover the stories students are
              talking about.
            </p>

            <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
              <Button asChild size="xl" className="w-full sm:w-auto">
                <Link href="/universities">
                  Explore universities
                  <ArrowRight />
                </Link>
              </Button>
              <Button asChild variant="outline" size="xl" className="w-full sm:w-auto">
                <Link href={session ? "/home" : "/signup"}>
                  {session ? "Go to my feed" : "Join the community"}
                </Link>
              </Button>
            </div>

            <p className="mt-4 text-xs text-muted-foreground">
              Free · No university email required · Post anonymously or under your name
            </p>
          </div>

          {/* product preview */}
          <div className="relative mx-auto mt-12 max-w-4xl">
            <div className="surface overflow-hidden p-2 shadow-[var(--shadow-lift)] sm:p-3">
              <div className="rounded-xl border border-border bg-background-subtle p-3 sm:p-4">
                <div className="mb-3 flex items-center gap-2">
                  <span className="size-2.5 rounded-full bg-danger/70" />
                  <span className="size-2.5 rounded-full bg-warning/70" />
                  <span className="size-2.5 rounded-full bg-success/70" />
                  <span className="ml-2 truncate rounded-md bg-muted px-2 py-0.5 text-[0.6875rem] text-muted-foreground">
                    campusly.pk/channels/fast-nuces-islamabad
                  </span>
                </div>

                <div className="grid gap-3 lg:grid-cols-[1.6fr_1fr]">
                  <div className="space-y-3">
                    {highlights.length > 0 ? (
                      highlights.slice(0, 2).map((post) => (
                        <PostCard key={post.id} post={post} variant="compact" />
                      ))
                    ) : (
                      <Card className="p-5">
                        <p className="text-sm text-muted-foreground">
                          Campus feeds appear here as students post. Be the first in your community.
                        </p>
                      </Card>
                    )}
                  </div>

                  <div className="space-y-3">
                    <Card className="p-4">
                      <p className="text-[0.8125rem] font-semibold">Trending on campus</p>
                      <ul className="mt-2.5 space-y-2">
                        {featured.length > 0 ? (
                          featured.slice(0, 5).map((topic) => (
                            <li key={topic.topic} className="flex items-center justify-between gap-3 text-[0.8125rem]">
                              <Link href={`/search?q=%23${topic.topic}&scope=posts`} className="truncate text-accent hover:underline">
                                #{topic.topic}
                              </Link>
                              <span className="shrink-0 text-xs tabular-nums text-muted-foreground">
                                {compactNumber(topic.post_count)} posts
                              </span>
                            </li>
                          ))
                        ) : (
                          <li className="text-xs text-muted-foreground">
                            Hashtags start trending once a community is active.
                          </li>
                        )}
                      </ul>
                    </Card>

                    <Card className="p-4">
                      <p className="text-[0.8125rem] font-semibold">How anonymity works</p>
                      <ul className="mt-2.5 space-y-2 text-xs text-muted-foreground">
                        <li className="flex gap-2">
                          <EyeOff className="mt-0.5 size-3.5 shrink-0 text-accent" aria-hidden />
                          Your name and photo are never sent to other students on an anonymous post.
                        </li>
                        <li className="flex gap-2">
                          <ShieldCheck className="mt-0.5 size-3.5 shrink-0 text-accent" aria-hidden />
                          Moderators can only reveal authorship through a logged, justified review.
                        </li>
                      </ul>
                    </Card>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ================================================= featured universities */}
      <section className="mx-auto max-w-6xl px-4 py-14 sm:px-6">
        <div className="flex flex-wrap items-end justify-between gap-3">
          <div>
            <h2 className="text-title">Find your campus</h2>
            <p className="mt-2 max-w-xl text-sm text-muted-foreground">
              {catalogue.universities > 0
                ? `${compactNumber(catalogue.universities)} institutions and ${compactNumber(catalogue.campuses)} campuses across ${catalogue.provinces} regions — each campus with its own community.`
                : "Every institution and campus gets its own community."}
            </p>
          </div>
          <Button asChild variant="outline" size="sm">
            <Link href="/universities">
              Browse all universities <ArrowRight />
            </Link>
          </Button>
        </div>

        <div className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {universities.length > 0 ? (
            universities.slice(0, 6).map((university) => (
              <UniversityCard key={university.id} university={university} signedIn={Boolean(session)} />
            ))
          ) : (
            <div className="sm:col-span-2 lg:col-span-3">
              <EmptyState
                icon={Building2}
                title="The catalogue is empty"
                description="Run `npm run db:local:reset -- --seed` (or paste supabase/seed/seed.sql into Supabase) to load the Pakistan university catalogue."
              />
            </div>
          )}
        </div>
      </section>

      {/* ===================================================== how it works */}
      <section className="border-y border-border bg-card py-14">
        <div className="mx-auto max-w-6xl px-4 sm:px-6">
          <div className="mx-auto max-w-xl text-center">
            <Badge variant="outline">How it works</Badge>
            <h2 className="text-title mt-3">From lurker to campus regular in four steps</h2>
          </div>

          <ol className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            {HOW_IT_WORKS.map((step, index) => (
              <li key={step.title} className="surface p-5">
                <span className="flex size-9 items-center justify-center rounded-lg bg-accent-subtle text-accent">
                  <step.icon className="size-4" aria-hidden />
                </span>
                <p className="mt-3 text-[0.6875rem] font-semibold uppercase tracking-wider text-muted-foreground">
                  Step {index + 1}
                </p>
                <h3 className="mt-1 text-[0.9375rem] font-semibold">{step.title}</h3>
                <p className="mt-1.5 text-sm leading-relaxed text-muted-foreground">{step.body}</p>
              </li>
            ))}
          </ol>
        </div>
      </section>

      {/* ========================================================= anonymity */}
      <section className="mx-auto max-w-6xl px-4 py-14 sm:px-6">
        <div className="surface overflow-hidden">
          <div className="grid gap-0 lg:grid-cols-2">
            <div className="p-6 sm:p-10">
              <Badge variant="subtle">
                <Lock className="size-3" aria-hidden /> Privacy
              </Badge>
              <h2 className="text-title mt-4">Anonymous to students. Accountable to the rules.</h2>
              <p className="mt-4 text-sm leading-relaxed text-muted-foreground">
                Anonymous means other students cannot see who you are. It does not mean the platform is blind. Your
                account is recorded privately at the moment of posting for one purpose only: enforcing the community
                guidelines against threats, doxxing and harassment.
              </p>
              <ul className="mt-6 space-y-3">
                {[
                  "Author identity is stored in a column that is removed from every client's permissions.",
                  "Feeds, search, share previews and notifications all return a null author for anonymous posts.",
                  "Only a moderator can request disclosure, and only with a written justification.",
                  "Every disclosure is written to an audit log and reviewable by administrators.",
                ].map((item) => (
                  <li key={item} className="flex gap-3 text-sm text-muted-foreground">
                    <ShieldCheck className="mt-0.5 size-4 shrink-0 text-success" aria-hidden />
                    {item}
                  </li>
                ))}
              </ul>
              <Button asChild variant="outline" size="sm" className="mt-6">
                <Link href="/privacy">
                  Read the privacy policy <ArrowRight />
                </Link>
              </Button>
            </div>

            <div className="border-t border-border bg-background-subtle p-6 sm:p-10 lg:border-l lg:border-t-0">
              <p className="text-[0.6875rem] font-semibold uppercase tracking-wider text-muted-foreground">
                What a student sees
              </p>
              <div className="mt-4 rounded-xl border border-border bg-card p-4 shadow-[var(--shadow-hairline)]">
                <div className="flex items-center gap-3">
                  <Avatar anonymous name="Anonymous" seed="preview" size="md" />
                  <div>
                    <p className="text-[0.8125rem] font-semibold text-muted-foreground">Anonymous</p>
                    <p className="text-xs text-muted-foreground">FAST-NUCES · Islamabad</p>
                  </div>
                </div>
                <p className="mt-3 text-[0.9375rem] leading-relaxed">
                  The café near Gate 2 has quietly become the best study spot on campus. That is all.
                </p>
              </div>

              <p className="mt-6 text-[0.6875rem] font-semibold uppercase tracking-wider text-muted-foreground">
                What the database stores
              </p>
              <pre className="mt-4 overflow-x-auto rounded-xl border border-border bg-ink-950 p-4 text-[0.6875rem] leading-relaxed text-ink-200">
{`posts
├─ id            uuid
├─ body          text
├─ is_anonymous  boolean  ← true
└─ author_id     uuid     ← private, revoked
                            from anon & authenticated`}
              </pre>
              <p className="mt-3 text-xs text-muted-foreground">
                Any client query for <code className="rounded bg-muted px-1">posts.author_id</code> is rejected by
                Postgres with a permission error — it is not filtered out afterwards.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* ========================================================== features */}
      <section className="border-y border-border bg-card py-14">
        <div className="mx-auto max-w-6xl px-4 sm:px-6">
          <div className="mx-auto max-w-xl text-center">
            <Badge variant="outline">What makes it work</Badge>
            <h2 className="text-title mt-3">Built for how students actually use a campus forum</h2>
          </div>

          <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {PLATFORM_FEATURES.map((feature) => (
              <Card key={feature.title} className="p-5">
                <span className="flex size-9 items-center justify-center rounded-lg bg-muted text-foreground">
                  <feature.icon className="size-4" aria-hidden />
                </span>
                <h3 className="mt-3 text-[0.9375rem] font-semibold">{feature.title}</h3>
                <p className="mt-1.5 text-sm leading-relaxed text-muted-foreground">{feature.body}</p>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* ============================================================== FAQ */}
      <section className="mx-auto max-w-3xl px-4 py-14 sm:px-6">
        <div className="text-center">
          <Badge variant="outline">FAQ</Badge>
          <h2 className="text-title mt-3">Questions students ask before joining</h2>
        </div>

        <div className="mt-8 space-y-2">
          {FAQS.map((faq) => (
            <details key={faq.q} className="surface group p-4 [&_summary::-webkit-details-marker]:hidden">
              <summary className="flex cursor-pointer items-center justify-between gap-4 text-[0.9375rem] font-medium">
                {faq.q}
                <span className="text-muted-foreground transition-transform group-open:rotate-45" aria-hidden>
                  +
                </span>
              </summary>
              <p className="mt-3 text-sm leading-relaxed text-muted-foreground">{faq.a}</p>
            </details>
          ))}
        </div>
      </section>

      {/* ============================================================== CTA */}
      <section className="mx-auto max-w-6xl px-4 pb-16 sm:px-6">
        <div className="relative overflow-hidden rounded-3xl border border-border bg-ink-950 px-6 py-14 text-center sm:px-12">
          <div className="grid-canvas pointer-events-none absolute inset-0 opacity-[0.07]" />
          <div className="relative">
            <BrandLockup className="mx-auto text-white" />
            <h2 className="text-title mx-auto mt-5 max-w-2xl text-white">
              Somebody on your campus is already talking about it.
            </h2>
            <p className="mx-auto mt-4 max-w-lg text-sm leading-relaxed text-ink-300">
              Join your campus community, read what students are actually saying, and add your voice.
            </p>
            <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
              <Button asChild size="xl" className="w-full bg-white text-ink-950 hover:bg-ink-100 sm:w-auto">
                <Link href={session ? "/home" : "/signup"}>
                  {session ? "Go to my feed" : "Create your account"}
                  <ArrowRight />
                </Link>
              </Button>
              <Button
                asChild
                variant="outline"
                size="xl"
                className="w-full border-white/20 bg-transparent text-white hover:bg-white/10 sm:w-auto"
              >
                <Link href="/universities">Find my university</Link>
              </Button>
            </div>
            <p className="mt-4 text-xs text-ink-400">
              {compactNumber(catalogue.channels)} campus communities · Free · Community-moderated
            </p>
          </div>
        </div>
      </section>
    </>
  );
}
