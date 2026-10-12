import type { Metadata } from "next";
import Link from "next/link";
import { AlertTriangle, Mail, ShieldAlert } from "lucide-react";

import { BRAND } from "@/components/brand";
import { Badge, Card } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";

export const metadata: Metadata = {
  title: `Report a Problem — ${BRAND.name}`,
  description: `Report urgent safety concerns, doxxing, or emergencies on ${BRAND.name}.`,
};

export default function ReportAbusePage() {
  return (
    <div className="mx-auto w-full max-w-3xl px-4 py-8 sm:py-14">
      <div className="mx-auto max-w-2xl text-center">
        <Badge variant="outline" size="sm" className="mb-3 shadow-2xs gap-1.5 border-danger/40 text-danger">
          <AlertTriangle className="size-3" />
          <span>Safety Escalation</span>
        </Badge>
        <h1 className="text-display text-foreground">Report a Problem</h1>
        <p className="mt-3 text-base text-muted-foreground leading-relaxed">
          If you have encountered urgent safety issues, doxxing, threats, or severe harassment on {BRAND.name}, please review the steps below.
        </p>
      </div>

      <div className="mt-12 space-y-6">
        <Card className="p-6 border-danger/40">
          <h2 className="text-base font-bold text-danger flex items-center gap-2">
            <ShieldAlert className="size-5 shrink-0" />
            Direct In-App Reporting (Fastest)
          </h2>
          <p className="mt-2 text-sm text-foreground leading-relaxed">
            Every post and comment has a <strong>three-dot menu (...)</strong> with a <strong>"Report"</strong> option. Submitting through that menu snapshots the exact content directly into our moderation queue for expedited review.
          </p>
        </Card>

        <Card className="p-6 space-y-4">
          <h3 className="text-base font-semibold text-foreground flex items-center gap-2">
            <Mail className="size-4 text-accent" />
            Email Emergency Support
          </h3>
          <p className="text-sm text-muted-foreground leading-relaxed">
            For critical matters involving personal safety, legal inquiries, or urgent content takedown requests, you can email our emergency safety contact directly:
          </p>
          <div className="rounded-xl border border-border bg-muted/50 p-4 text-sm font-mono text-foreground">
            safety@{BRAND.domain}
          </div>
          <p className="text-xs text-muted-foreground">
            Please include the URL of the post or university channel and a brief description of the violation.
          </p>
        </Card>

        <div className="pt-2 text-center">
          <Button asChild variant="outline">
            <Link href="/community-guidelines">Review Community Guidelines</Link>
          </Button>
        </div>
      </div>
    </div>
  );
}
