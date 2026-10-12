import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { Suspense } from "react";

import { AuthShell, SignInForm } from "@/components/auth/auth-forms";
import { Skeleton } from "@/components/ui/primitives";
import { env } from "@/lib/env";
import { getSessionUser } from "@/server/auth/session";

export const metadata: Metadata = {
  title: "Log in",
  description: "Sign in to Campusly to reach your university community.",
  robots: { index: false, follow: false },
};

export default async function LoginPage() {
  if (await getSessionUser()) redirect("/home");

  return (
    <AuthShell
      title="Welcome back"
      subtitle="Sign in to reach your campus community."
      footer={
        env.demoMode
          ? "Demo accounts are available on the seeded database — see README.md → 'Demo data'."
          : "By signing in you agree to the community guidelines and terms."
      }
    >
      <Suspense fallback={<Skeleton className="h-72 w-full" />}>
        <SignInForm />
      </Suspense>
    </AuthShell>
  );
}
