import { MobileComposeBar } from "@/components/layout/mobile-compose-bar";
import { SiteHeader } from "@/components/layout/site-header";
import { SiteFooter } from "@/components/layout/site-footer";
import { getCurrentContext } from "@/server/auth/context";
import { getMyChannels } from "@/server/services/queries";

/**
 * Signed-in shell.
 *
 * The mobile bottom bar needs to know whether the student has joined anything,
 * because "write a confession" without a community is a dead end — the bar
 * points at Explore in that case instead of pretending it can post.
 */
export default async function AppLayout({ children }: { children: React.ReactNode }) {
  const context = await getCurrentContext();
  const channels = context?.profile.onboardingCompleted
    ? await getMyChannels({ db: context.db, userId: context.id }, 1)
    : [];

  return (
    <div className="flex min-h-dvh flex-col bg-background">
      <SiteHeader variant="app" />
      <main id="main" className="relative z-10 flex-1 bg-background pb-20 md:pb-0">
        {children}
      </main>
      <SiteFooter />
      {context?.profile.onboardingCompleted ? <MobileComposeBar hasChannels={channels.length > 0} /> : null}
    </div>
  );
}
