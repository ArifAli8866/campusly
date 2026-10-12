import type { Metadata } from "next";
import Link from "next/link";
import { Building2, EyeOff, Heart, ShieldCheck } from "lucide-react";

import { BRAND } from "@/components/brand";
import { Badge, Card } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";

export const metadata: Metadata = {
  title: `About — ${BRAND.name}`,
  description: `About ${BRAND.name}: An independent, student-led campus discussion and confession platform for universities across Pakistan.`,
};

export default function AboutPage() {
  return (
    <div className="mx-auto w-full max-w-4xl px-4 py-8 sm:py-14">
      {/* Header */}
      <div className="mx-auto max-w-2xl text-center">
        <Badge variant="outline" size="sm" className="mb-3 shadow-2xs gap-1.5">
          <Heart className="size-3 text-danger fill-danger" />
          <span>Built For Students</span>
        </Badge>
        <h1 className="text-display text-foreground">
          About {BRAND.name}
        </h1>
        <p className="mt-3 text-base text-muted-foreground leading-relaxed">
          {BRAND.name} is an independent digital quad for Pakistani higher education. We build safe, private spaces for students to share stories, ask candid questions, and stay connected.
        </p>
      </div>

      {/* Core Principles */}
      <div className="mt-12 grid gap-6 sm:grid-cols-3">
        <Card className="p-5">
          <div className="flex size-10 items-center justify-center rounded-2xl bg-accent-subtle text-accent mb-3">
            <EyeOff className="size-5" />
          </div>
          <h2 className="text-base font-semibold text-foreground">Database-Level Privacy</h2>
          <p className="mt-2 text-xs sm:text-sm text-muted-foreground leading-relaxed">
            When you choose to post anonymously, your identity is not merely hidden with CSS — it is stripped at the database query level so client browsers never receive it.
          </p>
        </Card>

        <Card className="p-5">
          <div className="flex size-10 items-center justify-center rounded-2xl bg-accent-subtle text-accent mb-3">
            <Building2 className="size-5" />
          </div>
          <h2 className="text-base font-semibold text-foreground">Campus-Specific Spaces</h2>
          <p className="mt-2 text-xs sm:text-sm text-muted-foreground leading-relaxed">
            Every university and campus has its own dedicated forum. Discussion on Lahore campus stays relevant to Lahore students, without drowning out Islamabad or Peshawar.
          </p>
        </Card>

        <Card className="p-5">
          <div className="flex size-10 items-center justify-center rounded-2xl bg-accent-subtle text-accent mb-3">
            <ShieldCheck className="size-5" />
          </div>
          <h2 className="text-base font-semibold text-foreground">Accountable Moderation</h2>
          <p className="mt-2 text-xs sm:text-sm text-muted-foreground leading-relaxed">
            Anonymity is a privilege, not a license to harm. Our platform enforces strict rules against doxxing, harassment, and defamation with audit-logged reviews.
          </p>
        </Card>
      </div>

      {/* Narrative Section */}
      <div className="surface mt-10 p-6 sm:p-10 space-y-6 text-sm leading-relaxed text-muted-foreground">
        <h2 className="text-xl font-bold text-foreground">Why We Built {BRAND.name}</h2>
        <p>
          University life in Pakistan is vibrant, demanding, and full of untold stories. For years, students relied on unverified Facebook confession pages, Instagram meme handles, and fragmented WhatsApp groups that frequently leaked identities, lacked safety tools, or shut down without warning.
        </p>
        <p>
          {BRAND.name} was created by engineers and students to deliver modern software architecture to campus discourse: high performance, real-time engagement, beautiful design, and rock-solid privacy engineering.
        </p>
        <p>
          Whether you need advice about difficult professors, want to celebrate exam season survival, lost an item in the cafeteria, or simply want to speak your mind without social pressure, {BRAND.name} is your home.
        </p>

        <div className="pt-4 border-t border-border flex flex-wrap gap-3">
          <Button asChild size="md">
            <Link href="/universities">Find Your University</Link>
          </Button>
          <Button asChild variant="outline" size="md">
            <Link href="/community-guidelines">Read Guidelines</Link>
          </Button>
        </div>
      </div>
    </div>
  );
}
