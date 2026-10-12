import type { Metadata } from "next";
import { Lock, ShieldCheck } from "lucide-react";

import { BRAND } from "@/components/brand";
import { Badge } from "@/components/ui/primitives";

export const metadata: Metadata = {
  title: `Privacy Policy — ${BRAND.name}`,
  description: `Privacy policy and anonymous data handling practices for ${BRAND.name}.`,
};

export default function PrivacyPage() {
  return (
    <div className="mx-auto w-full max-w-4xl px-4 py-8 sm:py-14">
      <div className="mx-auto max-w-2xl text-center">
        <Badge variant="outline" size="sm" className="mb-3 shadow-2xs gap-1.5">
          <Lock className="size-3 text-accent" />
          <span>Privacy By Design</span>
        </Badge>
        <h1 className="text-display text-foreground">Privacy Policy</h1>
        <p className="mt-3 text-base text-muted-foreground leading-relaxed">
          How {BRAND.name} protects your identity, stores campus data, and enforces anonymous confidentiality.
        </p>
      </div>

      <div className="surface mt-12 p-6 sm:p-10 space-y-8 text-sm leading-relaxed text-muted-foreground">
        <section className="space-y-3">
          <h2 className="text-lg font-bold text-foreground flex items-center gap-2">
            <ShieldCheck className="size-5 text-accent" />
            1. Anonymity Guarantee
          </h2>
          <p>
            When you publish a post or comment marked as <strong>Anonymous</strong>, your display name, username, avatar, and account identifier are stripped before database query results leave our servers.
          </p>
          <p>
            Other students, alumni, and regular visitors can never see who published an anonymous post, even if they inspect network requests or API payloads.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-foreground">2. Information We Collect</h2>
          <ul className="list-disc pl-5 space-y-1.5">
            <li><strong>Account details:</strong> Email address, chosen display name, username, and password hash (or Google OAuth tokens).</li>
            <li><strong>Academic profile (optional):</strong> University, campus, department, degree program, and graduation year.</li>
            <li><strong>Activity:</strong> Posts, confessions, comments, likes, saved items, and community memberships.</li>
            <li><strong>Safety logs:</strong> Secure internal attribution logs retained solely to act upon legal violations, actionable threats of self-harm, or severe harassment.</li>
          </ul>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-foreground">3. How Your Information Is Used</h2>
          <p>
            We use your data strictly to operate {BRAND.name}: delivering your campus feed, displaying notifications, and maintaining platform security. We <strong>never</strong> sell personal student data or share information with commercial advertisers.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-foreground">4. Data Deletion & Rights</h2>
          <p>
            You have full control over your data. You may delete any post or comment you authored at any time. You may also delete your account and personal profile data permanently through settings or by contacting our team.
          </p>
        </section>
      </div>
    </div>
  );
}
