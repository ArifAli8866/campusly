import type { Metadata } from "next";

import { AuthShell, ForgotPasswordForm } from "@/components/auth/auth-forms";

export const metadata: Metadata = {
  title: "Reset your password",
  robots: { index: false, follow: false },
};

export default function ForgotPasswordPage() {
  return (
    <AuthShell
      title="Forgot your password?"
      subtitle="Enter your email address and we will send you a secure reset link."
    >
      <ForgotPasswordForm />
    </AuthShell>
  );
}
