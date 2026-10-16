import { SiteFooter } from "@/components/layout/site-footer";
import { SiteHeader } from "@/components/layout/site-header";

export default function SiteLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-dvh flex-col bg-background">
      <SiteHeader variant="site" />
      <main id="main" className="relative z-10 flex-1 bg-background">
        {children}
      </main>
      <SiteFooter />
    </div>
  );
}
