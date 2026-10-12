import type { Metadata } from "next";
import { FileText } from "lucide-react";

import { BRAND } from "@/components/brand";
import { Badge } from "@/components/ui/primitives";

export const metadata: Metadata = {
  title: `Terms of Service — ${BRAND.name}`,
  description: `Terms and conditions for using ${BRAND.name}.`,
};

export default function TermsPage() {
  return (
    <div className="mx-auto w-full max-w-4xl px-4 py-8 sm:py-14">
      <div className="mx-auto max-w-2xl text-center">
        <Badge variant="outline" size="sm" className="mb-3 shadow-2xs gap-1.5">
          <FileText className="size-3 text-accent" />
          <span>Terms of Use</span>
        </Badge>
        <h1 className="text-display text-foreground">Terms of Service</h1>
        <p className="mt-3 text-base text-muted-foreground leading-relaxed">
          Please review the rules that govern your access and use of {BRAND.name}.
        </p>
      </div>

      <div className="surface mt-12 p-6 sm:p-10 space-y-8 text-sm leading-relaxed text-muted-foreground">
        <section className="space-y-3">
          <h2 className="text-lg font-bold text-foreground">1. Acceptance of Terms</h2>
          <p>
            By creating an account or using {BRAND.name}, you agree to these Terms of Service and our Community Guidelines. If you do not agree, do not use the service.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-foreground">2. Student Responsibility</h2>
          <p>
            You are responsible for all activity under your account and for all content you publish. You agree not to post content that infringes upon copyright, violates local laws, or harms other students.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-foreground">3. Non-Affiliation Disclaimer</h2>
          <p>
            {BRAND.name} is an independent platform and is not officially affiliated with, endorsed by, or sponsored by any Pakistani university or higher education institution unless explicitly noted.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-foreground">4. Account Termination</h2>
          <p>
            We reserve the right to suspend or terminate accounts that violate our Community Guidelines, engage in doxxing, harassment, or attempt to compromise platform security.
          </p>
        </section>
      </div>
    </div>
  );
}
