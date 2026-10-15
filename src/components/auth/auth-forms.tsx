"use client";

import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useState, useTransition } from "react";
import { ArrowRight, Eye, EyeOff, Mail } from "lucide-react";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Checkbox, Field, InlineAlert, Input } from "@/components/ui/fields";
import { Label } from "@/components/ui/primitives";
import { cn } from "@/lib/utils";
import { forgotPasswordAction, googleOAuthAction, signInAction, signUpAction } from "@/server/actions/auth";

/* ------------------------------------------------------------------ shared */

function GoogleButton({ next, label }: { next: string; label: string }) {
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);

  function go() {
    setError(null);
    startTransition(async () => {
      const formData = new FormData();
      formData.set("next", next);
      const result = await googleOAuthAction(formData);

      if (!result.ok || !result.data?.url) {
        setError(result.ok ? "Google sign-in is unavailable." : result.error);
        return;
      }
      window.location.href = result.data.url;
    });
  }

  return (
    <div className="space-y-2">
      <Button type="button" variant="outline" size="lg" className="w-full" onClick={go} loading={isPending}>
        <GoogleMark />
        {label}
      </Button>
      {error ? <InlineAlert tone="warning">{error}</InlineAlert> : null}
    </div>
  );
}

function GoogleMark() {
  return (
    <svg viewBox="0 0 24 24" className="size-4" aria-hidden>
      <path
        fill="#4285F4"
        d="M23.06 12.25c0-.85-.08-1.67-.22-2.45H12v4.64h6.2a5.3 5.3 0 0 1-2.3 3.48v2.89h3.72c2.18-2 3.44-4.96 3.44-8.56Z"
      />
      <path
        fill="#34A853"
        d="M12 24c3.11 0 5.72-1.03 7.62-2.79l-3.72-2.89c-1.03.69-2.35 1.1-3.9 1.1-3 0-5.54-2.03-6.45-4.75H1.7v2.98A11.99 11.99 0 0 0 12 24Z"
      />
      <path fill="#FBBC05" d="M5.55 14.67a7.2 7.2 0 0 1 0-4.6V7.09H1.7a12 12 0 0 0 0 10.56l3.85-2.98Z" />
      <path
        fill="#EA4335"
        d="M12 4.75c1.69 0 3.2.58 4.4 1.72l3.3-3.3C17.71 1.24 15.1 0 12 0A11.99 11.99 0 0 0 1.7 7.09l3.85 2.98C6.46 7.35 9 4.75 12 4.75Z"
      />
    </svg>
  );
}

function FormError({ message }: { message: string | null }) {
  if (!message) return null;
  return <InlineAlert tone="danger">{message}</InlineAlert>;
}

/* ------------------------------------------------------------------ sign in */

export function SignInForm() {
  const router = useRouter();
  const params = useSearchParams();
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);
  const [showPassword, setShowPassword] = useState(false);

  const next = params.get("next") ?? "/home";
  const checkedEmail = params.get("check-email") === "1";
  const urlError = params.get("error");

  function submit(formData: FormData) {
    setError(null);
    formData.set("next", next);

    startTransition(async () => {
      const result = await signInAction(formData);
      if (!result.ok) {
        setError(result.error);
        return;
      }
      toast.success("Welcome back.");
      router.push(result.data?.next ?? "/home");
      router.refresh();
    });
  }

  return (
    <div className="space-y-5">
      {checkedEmail ? (
        <InlineAlert tone="info" title="Confirm your email">
          We sent you a confirmation link. Open it, then sign in here.
        </InlineAlert>
      ) : null}

      {urlError ? (
        <InlineAlert tone="danger" title="Authentication error">
          {urlError}
        </InlineAlert>
      ) : null}

      <GoogleButton next={next} label="Continue with Google" />

      <div className="flex items-center gap-3">
        <span className="h-px flex-1 bg-border" />
        <span className="text-xs text-muted-foreground">or use your email</span>
        <span className="h-px flex-1 bg-border" />
      </div>

      <form action={submit} className="space-y-4">
        <Field label="Email address" htmlFor="signin-email">
          <Input
            id="signin-email"
            name="email"
            type="email"
            autoComplete="email"
            required
            placeholder="you@example.com"
          />
        </Field>

        <Field label="Password" htmlFor="signin-password">
          <div className="relative">
            <Input
              id="signin-password"
              name="password"
              type={showPassword ? "text" : "password"}
              autoComplete="current-password"
              required
              className="pr-10"
            />
            <button
              type="button"
              onClick={() => setShowPassword((value) => !value)}
              className="absolute right-2 top-1/2 -translate-y-1/2 rounded-md p-1.5 text-muted-foreground hover:text-foreground"
              aria-label={showPassword ? "Hide password" : "Show password"}
            >
              {showPassword ? <EyeOff className="size-4" /> : <Eye className="size-4" />}
            </button>
          </div>
        </Field>

        <div className="flex items-center justify-between">
          <Link href="/forgot-password" className="text-xs font-medium text-accent hover:underline">
            Forgot your password?
          </Link>
        </div>

        <FormError message={error} />

        <Button type="submit" size="lg" className="w-full" loading={isPending} loadingLabel="Signing in…">
          Sign in <ArrowRight />
        </Button>
      </form>

      <p className="text-center text-sm text-muted-foreground">
        New to Campusly?{" "}
        <Link href={`/signup?next=${encodeURIComponent(next)}`} className="font-medium text-accent hover:underline">
          Create an account
        </Link>
      </p>
    </div>
  );
}

/* ------------------------------------------------------------------ sign up */

export function SignUpForm() {
  const router = useRouter();
  const params = useSearchParams();
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);
  const [accepted, setAccepted] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const urlError = params.get("error");

  function submit(formData: FormData) {
    setError(null);
    formData.set("acceptGuidelines", String(accepted));

    startTransition(async () => {
      const result = await signUpAction(formData);
      if (!result.ok) {
        setError(result.error);
        return;
      }
      toast.success(result.message ?? "Account created.");
      router.push(result.data?.next ?? "/onboarding");
      router.refresh();
    });
  }

  return (
    <div className="space-y-5">
      {urlError ? (
        <InlineAlert tone="danger" title="Authentication error">
          {urlError}
        </InlineAlert>
      ) : null}

      <GoogleButton next={params.get("next") ?? "/onboarding"} label="Sign up with Google" />

      <div className="flex items-center gap-3">
        <span className="h-px flex-1 bg-border" />
        <span className="text-xs text-muted-foreground">or use your email</span>
        <span className="h-px flex-1 bg-border" />
      </div>

      <form action={submit} className="space-y-4">
        <Field label="Display name" htmlFor="signup-name" hint="This is what other students will see.">
          <Input id="signup-name" name="displayName" required autoComplete="name" maxLength={60} placeholder="Ayesha Khan" />
        </Field>

        <Field label="Email address" htmlFor="signup-email" hint="Any email works — a university address is not required.">
          <Input id="signup-email" name="email" type="email" required autoComplete="email" placeholder="you@example.com" />
        </Field>

        <Field
          label="Password"
          htmlFor="signup-password"
          hint="At least 8 characters, including a letter and a number."
        >
          <div className="relative">
            <Input
              id="signup-password"
              name="password"
              type={showPassword ? "text" : "password"}
              required
              minLength={8}
              autoComplete="new-password"
              className="pr-10"
            />
            <button
              type="button"
              onClick={() => setShowPassword((value) => !value)}
              className="absolute right-2 top-1/2 -translate-y-1/2 rounded-md p-1.5 text-muted-foreground hover:text-foreground"
              aria-label={showPassword ? "Hide password" : "Show password"}
            >
              {showPassword ? <EyeOff className="size-4" /> : <Eye className="size-4" />}
            </button>
          </div>
        </Field>

        <div className="flex items-start gap-2.5 rounded-xl border border-border bg-muted/40 p-3">
          <Checkbox
            id="signup-guidelines"
            checked={accepted}
            onCheckedChange={(value) => setAccepted(value === true)}
            aria-describedby="signup-guidelines-label"
          />
          <Label htmlFor="signup-guidelines" id="signup-guidelines-label" className="text-xs font-normal leading-relaxed text-muted-foreground">
            I am 16 or older, I have read the{" "}
            <Link href="/community-guidelines" className="font-medium text-accent hover:underline" target="_blank">
              community guidelines
            </Link>{" "}
            and{" "}
            <Link href="/terms" className="font-medium text-accent hover:underline" target="_blank">
              terms
            </Link>
            , and I will not use Campusly to harass or expose anyone.
          </Label>
        </div>

        <FormError message={error} />

        <Button
          type="submit"
          size="lg"
          className="w-full"
          loading={isPending}
          loadingLabel="Creating account…"
          disabled={!accepted}
        >
          Create my account <ArrowRight />
        </Button>

        <p className="flex items-start gap-1.5 text-xs text-muted-foreground">
          <Mail className="mt-0.5 size-3 shrink-0" aria-hidden />
          We never ask for your student ID, CNIC or a password for any other service.
        </p>
      </form>

      <p className="text-center text-sm text-muted-foreground">
        Already have an account?{" "}
        <Link href="/login" className="font-medium text-accent hover:underline">
          Sign in
        </Link>
      </p>
    </div>
  );
}

/* -------------------------------------------------------- forgot / reset */

export function ForgotPasswordForm() {
  const [isPending, startTransition] = useTransition();
  const [sent, setSent] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  function submit(formData: FormData) {
    setError(null);
    startTransition(async () => {
      const result = await forgotPasswordAction(formData);
      if (!result.ok) {
        setError(result.error);
        return;
      }
      setSent(result.message ?? "Check your inbox.");
    });
  }

  if (sent) {
    return (
      <InlineAlert tone="success" title="Check your inbox">
        {sent}
      </InlineAlert>
    );
  }

  return (
    <form action={submit} className="space-y-4">
      <Field label="Email address" htmlFor="forgot-email">
        <Input id="forgot-email" name="email" type="email" required autoComplete="email" placeholder="you@example.com" />
      </Field>

      <FormError message={error} />

      <Button type="submit" size="lg" className="w-full" loading={isPending} loadingLabel="Sending…">
        Send reset link
      </Button>

      <p className="text-center text-xs text-muted-foreground">
        For security we do not reveal whether an address has an account.
      </p>
    </form>
  );
}

export function ResetPasswordForm() {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);

  function submit(formData: FormData) {
    setError(null);
    const password = String(formData.get("password") ?? "");
    const confirm = String(formData.get("confirm") ?? "");

    if (password !== confirm) {
      setError("Those passwords do not match.");
      return;
    }

    startTransition(async () => {
      const { updatePasswordAction } = await import("@/server/actions/account");
      const result = await updatePasswordAction(password);
      if (!result.ok) {
        setError(result.error);
        return;
      }
      toast.success("Password updated. Please sign in.");
      router.push("/login");
    });
  }

  return (
    <form action={submit} className="space-y-4">
      <Field label="New password" htmlFor="reset-password" hint="At least 8 characters with a letter and a number.">
        <Input id="reset-password" name="password" type="password" required minLength={8} autoComplete="new-password" />
      </Field>

      <Field label="Confirm new password" htmlFor="reset-confirm">
        <Input id="reset-confirm" name="confirm" type="password" required minLength={8} autoComplete="new-password" />
      </Field>

      <FormError message={error} />

      <Button type="submit" size="lg" className="w-full" loading={isPending} loadingLabel="Updating…">
        Update password
      </Button>
    </form>
  );
}

/* ------------------------------------------------------------------ layout */

export function AuthShell({
  title,
  subtitle,
  children,
  footer,
}: {
  title: string;
  subtitle?: string;
  children: React.ReactNode;
  footer?: React.ReactNode;
}) {
  return (
    <div className={cn("mx-auto w-full max-w-md px-4 py-12 sm:py-16")}>
      <div className="surface p-6 sm:p-8">
        <h1 className="text-2xl font-semibold tracking-[-0.025em]">{title}</h1>
        {subtitle ? <p className="mt-1.5 text-sm text-muted-foreground">{subtitle}</p> : null}
        <div className="mt-6">{children}</div>
      </div>
      {footer ? <div className="mt-5 text-center text-xs text-muted-foreground">{footer}</div> : null}
    </div>
  );
}
