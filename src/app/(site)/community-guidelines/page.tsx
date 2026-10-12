import type { Metadata } from "next";
import Link from "next/link";
import { CheckCircle2, Flag, Shield, XCircle } from "lucide-react";

import { BRAND } from "@/components/brand";
import { Badge, Card } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";

export const metadata: Metadata = {
  title: `Community Guidelines — ${BRAND.name}`,
  description: `Community rules and content guidelines for ${BRAND.name} campus forums.`,
};

export default function CommunityGuidelinesPage() {
  return (
    <div className="mx-auto w-full max-w-4xl px-4 py-8 sm:py-14">
      <div className="mx-auto max-w-2xl text-center">
        <Badge variant="outline" size="sm" className="mb-3 shadow-2xs gap-1.5">
          <Shield className="size-3 text-accent" />
          <span>Safety & Trust</span>
        </Badge>
        <h1 className="text-display text-foreground">
          Community Guidelines
        </h1>
        <p className="mt-3 text-base text-muted-foreground leading-relaxed">
          {BRAND.name} is built on mutual respect and privacy. By participating in your campus community, you agree to abide by these simple rules.
        </p>
      </div>

      <div className="mt-12 space-y-8">
        {/* Prohibited items */}
        <Card className="p-6 sm:p-8 border-danger/30">
          <h2 className="flex items-center gap-2 text-lg font-bold text-danger">
            <XCircle className="size-5 shrink-0" />
            Strictly Prohibited
          </h2>
          <ul className="mt-4 space-y-3 text-sm text-foreground">
            <li className="flex items-start gap-2">
              <span className="font-bold text-danger">•</span>
              <span><strong>No Doxxing:</strong> Never share personal phone numbers, CNIC, room numbers, private social media profiles, or non-public personal details.</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="font-bold text-danger">•</span>
              <span><strong>No Harassment or Bullying:</strong> Targeting specific students with insults, persistent humiliation, or defamation is strictly banned.</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="font-bold text-danger">•</span>
              <span><strong>No Hate Speech:</strong> Content attacking individuals based on religion, ethnicity, gender, language, or sectarian identity results in immediate permanent bans.</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="font-bold text-danger">•</span>
              <span><strong>No Threats or Harm:</strong> Threats of violence or non-consensual imagery violate law and are escalated immediately to authorities.</span>
            </li>
          </ul>
        </Card>

        {/* Encouraged behavior */}
        <Card className="p-6 sm:p-8 border-success/30">
          <h2 className="flex items-center gap-2 text-lg font-bold text-success">
            <CheckCircle2 className="size-5 shrink-0" />
            What We Encourage
          </h2>
          <ul className="mt-4 space-y-3 text-sm text-foreground">
            <li className="flex items-start gap-2">
              <span className="font-bold text-success">•</span>
              <span><strong>Academic Camaraderie:</strong> Course reviews, study group coordination, book exchanges, and internship opportunities.</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="font-bold text-success">•</span>
              <span><strong>Honest Campus Life:</strong> Hostel experiences, cafeteria recommendations, university event highlights, and lighthearted humor.</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="font-bold text-success">•</span>
              <span><strong>Constructive Feedback:</strong> Thoughtful discussions about campus infrastructure, transit, and student council activities.</span>
            </li>
          </ul>
        </Card>

        {/* Reporting */}
        <Card className="p-6 bg-muted/40">
          <h3 className="flex items-center gap-2 text-base font-semibold text-foreground">
            <Flag className="size-4 text-warning" />
            How Enforcement Works
          </h3>
          <p className="mt-2 text-xs sm:text-sm text-muted-foreground leading-relaxed">
            Every confession, comment, or user profile includes a <strong>Report</strong> option. Reports are immediately queued for human moderator review. When a post is confirmed to violate guidelines, it is hidden or permanently deleted, and offending accounts are restricted or suspended.
          </p>
          <div className="mt-4">
            <Button asChild size="sm" variant="outline">
              <Link href="/report-abuse">Report an Urgent Problem</Link>
            </Button>
          </div>
        </Card>
      </div>
    </div>
  );
}
