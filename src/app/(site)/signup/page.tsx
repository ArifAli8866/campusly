import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { Suspense } from "react";

import { AuthShell, SignUpForm } from "@/components/auth/auth-forms";
import { Skeleton } from "@/components/ui/primitives";
import { getSessionUser } from "@/server/auth/session";

export const metadata: Metadata = {
  title: "Create your account",
  description:
    "Join Campusly, choose your university and campus, and start reading and writing in your campus community. No university email required.",
  robots: { index: true, follow: true },
};

export default async function SignUpPage() {
  if (await getSessionUser()) redirect("/home");

  return (
    <AuthShell
      title="Join your campus"
      subtitle="Two minutes to set up. You can stay anonymous the whole time."
    >
      <Suspense fallback={<Skeleton className="h-96 w-full" />}>
        <SignUpForm />
      </Suspense>
    </AuthShell>
  );
}
