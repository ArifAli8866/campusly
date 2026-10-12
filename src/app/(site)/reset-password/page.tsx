import type { Metadata } from "next";

import { AuthShell, ResetPasswordForm } from "@/components/auth/auth-forms";

export const metadata: Metadata = {
  title: "Choose a new password",
  robots: { index: false, follow: false },
};

export default function ResetPasswordPage() {
  return (
    <AuthShell
      title="Choose a new password"
      subtitle="Supabase (or your local session) must have verified you to reach this page."
    >
      <ResetPasswordForm />
    </AuthShell>
  );
}
