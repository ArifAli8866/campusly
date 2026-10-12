
/**
 * Small, shared building blocks that shadcn/ui would otherwise generate as
 * separate files. Kept together because they are all variations on the same
 * surface + typography tokens, and keeping them in one place makes the design
 * system easier to review and re-skin.
 */

import * as React from "react";
import * as AvatarPrimitive from "@radix-ui/react-avatar";
import * as LabelPrimitive from "@radix-ui/react-label";
import * as SeparatorPrimitive from "@radix-ui/react-separator";
import * as SwitchPrimitive from "@radix-ui/react-switch";
import { cva, type VariantProps } from "class-variance-authority";

import { cn, hueFrom, initials } from "@/lib/utils";

/* ------------------------------------------------------------------- Card */

export function Card({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn("rounded-2xl border border-border/80 bg-card text-card-foreground shadow-[var(--shadow-soft)] transition-all duration-200", className)}
      {...props}
    />
  );
}

export function CardHeader({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("flex flex-col gap-1 p-5 pb-3", className)} {...props} />;
}

export function CardTitle({ className, ...props }: React.HTMLAttributes<HTMLHeadingElement>) {
  return <h3 className={cn("text-[0.9375rem] font-semibold tracking-[-0.01em]", className)} {...props} />;
}

export function CardDescription({ className, ...props }: React.HTMLAttributes<HTMLParagraphElement>) {
  return <p className={cn("text-sm text-muted-foreground", className)} {...props} />;
}

export function CardContent({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("p-5 pt-0", className)} {...props} />;
}

export function CardFooter({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("flex items-center gap-2 p-5 pt-0", className)} {...props} />;
}

/* ------------------------------------------------------------------ Badge */

const badgeVariants = cva(
  "inline-flex items-center gap-1 rounded-full border font-medium leading-none whitespace-nowrap [&_svg]:size-3",
  {
    variants: {
      variant: {
        neutral: "border-border bg-muted text-muted-foreground",
        outline: "border-border bg-card text-foreground",
        accent: "border-transparent bg-accent text-accent-foreground",
        subtle: "border-transparent bg-accent-subtle text-accent",
        success: "border-transparent bg-success-subtle text-success",
        warning: "border-transparent bg-warning-subtle text-warning",
        danger: "border-transparent bg-danger-subtle text-danger",
        info: "border-transparent bg-info-subtle text-info",
        solid: "border-transparent bg-primary text-primary-foreground",
      },
      size: {
        sm: "px-1.5 py-0.5 text-[0.6875rem]",
        md: "px-2 py-[0.1875rem] text-xs",
        lg: "px-2.5 py-1 text-[0.8125rem]",
      },
    },
    defaultVariants: { variant: "neutral", size: "md" },
  },
);

export interface BadgeProps
  extends React.HTMLAttributes<HTMLSpanElement>,
    VariantProps<typeof badgeVariants> {}

export function Badge({ className, variant, size, ...props }: BadgeProps) {
  return <span className={cn(badgeVariants({ variant, size }), className)} {...props} />;
}

/* ----------------------------------------------------------------- Avatar */

export function Avatar({
  src,
  name,
  className,
  size = "md",
  anonymous = false,
  seed,
}: {
  src?: string | null;
  name?: string | null;
  className?: string;
  size?: "xs" | "sm" | "md" | "lg" | "xl";
  /** Renders the neutral "?" avatar used for anonymous authors. */
  anonymous?: boolean;
  /** Stable colour seed — use the post id, never anything identifying. */
  seed?: string;
}) {
  const sizes: Record<string, string> = {
    xs: "size-6 text-[0.625rem]",
    sm: "size-8 text-[0.6875rem]",
    md: "size-10 text-xs",
    lg: "size-14 text-sm",
    xl: "size-20 text-lg",
  };

  const hue = hueFrom(seed ?? name ?? "campusly");

  return (
    <AvatarPrimitive.Root
      className={cn(
        "relative flex shrink-0 overflow-hidden rounded-full border border-border bg-muted",
        sizes[size],
        className,
      )}
    >
      {src && !anonymous ? (
        <AvatarPrimitive.Image src={src} alt={name ? `${name}'s avatar` : "Avatar"} className="size-full object-cover" />
      ) : null}
      <AvatarPrimitive.Fallback
        delayMs={src && !anonymous ? 200 : 0}
        className={cn(
          "flex size-full items-center justify-center font-semibold uppercase",
          anonymous ? "bg-muted text-muted-foreground" : "text-ink-950",
        )}
        style={
          anonymous
            ? undefined
            : { backgroundColor: `hsl(${hue} 72% 88%)`, color: `hsl(${hue} 55% 26%)` }
        }
      >
        {anonymous ? (
          <span aria-hidden className="text-[1.05em] leading-none">
            ?
          </span>
        ) : (
          initials(name ?? "?")
        )}
      </AvatarPrimitive.Fallback>
    </AvatarPrimitive.Root>
  );
}

/* ------------------------------------------------------------------ Label */

export const Label = React.forwardRef<
  React.ComponentRef<typeof LabelPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof LabelPrimitive.Root>
>(({ className, ...props }, ref) => (
  <LabelPrimitive.Root
    ref={ref}
    className={cn("text-[0.8125rem] font-medium text-foreground", className)}
    {...props}
  />
));
Label.displayName = "Label";

/* -------------------------------------------------------------- Separator */

export function Separator({
  className,
  orientation = "horizontal",
  ...props
}: React.ComponentPropsWithoutRef<typeof SeparatorPrimitive.Root>) {
  return (
    <SeparatorPrimitive.Root
      orientation={orientation}
      className={cn(
        "shrink-0 bg-border",
        orientation === "horizontal" ? "h-px w-full" : "h-full w-px",
        className,
      )}
      {...props}
    />
  );
}

/* ----------------------------------------------------------------- Switch */

export const Switch = React.forwardRef<
  React.ComponentRef<typeof SwitchPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof SwitchPrimitive.Root>
>(({ className, ...props }, ref) => (
  <SwitchPrimitive.Root
    ref={ref}
    className={cn(
      "peer inline-flex h-[1.375rem] w-10 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors",
      "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background",
      "disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-accent data-[state=unchecked]:bg-border-strong",
      className,
    )}
    {...props}
  >
    <SwitchPrimitive.Thumb className="pointer-events-none block size-[1.125rem] rounded-full bg-white shadow-sm transition-transform data-[state=checked]:translate-x-[1.125rem] data-[state=unchecked]:translate-x-0" />
  </SwitchPrimitive.Root>
));
Switch.displayName = "Switch";

/* ------------------------------------------------------------- EmptyState */

export function EmptyState({
  icon: Icon,
  title,
  description,
  action,
  className,
}: {
  icon?: React.ComponentType<{ className?: string }>;
  title: string;
  description?: string;
  action?: React.ReactNode;
  className?: string;
}) {
  return (
    <div
      className={cn(
        "flex flex-col items-center justify-center gap-3 rounded-xl border border-dashed border-border bg-card/50 px-6 py-12 text-center",
        className,
      )}
    >
      {Icon ? (
        <span className="flex size-11 items-center justify-center rounded-xl bg-muted text-muted-foreground">
          <Icon className="size-5" aria-hidden />
        </span>
      ) : null}
      <div className="space-y-1">
        <p className="text-[0.9375rem] font-semibold">{title}</p>
        {description ? (
          <p className="mx-auto max-w-sm text-sm text-muted-foreground">{description}</p>
        ) : null}
      </div>
      {action}
    </div>
  );
}

/* --------------------------------------------------------------- Skeleton */

export function Skeleton({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("skeleton", className)} aria-hidden {...props} />;
}

export function PostCardSkeleton() {
  return (
    <div className="surface p-5">
      <div className="flex items-center gap-3">
        <Skeleton className="size-10 rounded-full" />
        <div className="space-y-2">
          <Skeleton className="h-3 w-32" />
          <Skeleton className="h-2.5 w-20" />
        </div>
      </div>
      <div className="mt-4 space-y-2.5">
        <Skeleton className="h-3 w-full" />
        <Skeleton className="h-3 w-[88%]" />
        <Skeleton className="h-3 w-[62%]" />
      </div>
      <div className="mt-5 flex gap-5">
        <Skeleton className="h-4 w-12" />
        <Skeleton className="h-4 w-12" />
        <Skeleton className="h-4 w-12" />
      </div>
    </div>
  );
}

export function UniversityCardSkeleton() {
  return (
    <div className="surface overflow-hidden">
      <Skeleton className="h-24 w-full rounded-none" />
      <div className="space-y-3 p-5">
        <Skeleton className="h-4 w-2/3" />
        <Skeleton className="h-3 w-1/3" />
        <Skeleton className="h-8 w-full" />
      </div>
    </div>
  );
}
