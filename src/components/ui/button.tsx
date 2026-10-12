import * as React from "react";
import { Slot } from "@radix-ui/react-slot";
import { Loader2 } from "lucide-react";
import { cva, type VariantProps } from "class-variance-authority";

import { cn } from "@/lib/utils";

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-full font-medium transition-all duration-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background disabled:pointer-events-none disabled:opacity-50 active:scale-[0.98] [&_svg]:shrink-0 cursor-pointer",
  {
    variants: {
      variant: {
        primary: "bg-primary text-primary-foreground hover:bg-primary/90 shadow-[0_8px_20px_-4px_rgba(0,0,0,0.22)] hover:shadow-[0_12px_24px_-4px_rgba(0,0,0,0.3)] hover:-translate-y-0.5",
        accent: "bg-accent text-accent-foreground hover:bg-accent/90 shadow-[0_8px_20px_-4px_rgba(99,102,241,0.35)] hover:-translate-y-0.5",
        outline: "border border-border/80 bg-card/80 backdrop-blur-sm text-foreground hover:border-border-strong hover:bg-muted shadow-xs hover:-translate-y-0.5",
        ghost: "text-muted-foreground hover:bg-muted/80 hover:text-foreground",
        subtle: "bg-accent-subtle text-accent hover:bg-accent-subtle/80 hover:-translate-y-0.5",
        danger: "bg-danger text-white hover:bg-danger/90 shadow-sm",
        link: "text-accent underline-offset-4 hover:underline p-0 h-auto rounded-none shadow-none",
      },
      size: {
        sm: "h-8 px-3.5 text-[0.8125rem] [&_svg]:size-3.5",
        md: "h-9.5 px-4.5 text-sm [&_svg]:size-4",
        lg: "h-11 px-5.5 text-[0.9375rem] [&_svg]:size-4.5",
        xl: "h-12 px-7 text-base [&_svg]:size-5 font-semibold",
        icon: "size-9 [&_svg]:size-4",
        "icon-sm": "size-7 [&_svg]:size-3.5",
      },
    },
    defaultVariants: { variant: "primary", size: "md" },
  },
);

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean;
  loading?: boolean;
  loadingLabel?: string;
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, loading = false, loadingLabel, children, disabled, ...props }, ref) => {
    const Component = asChild ? Slot : "button";

    if (asChild) {
      // Slot accepts exactly one child; the caller supplies it.
      return (
        <Component ref={ref} className={cn(buttonVariants({ variant, size }), className)} {...props}>
          {children}
        </Component>
      );
    }

    return (
      <button
        ref={ref}
        className={cn(buttonVariants({ variant, size }), className)}
        disabled={disabled || loading}
        aria-busy={loading || undefined}
        {...props}
      >
        {loading ? <Loader2 className="animate-spin" aria-hidden /> : null}
        {loading && loadingLabel ? loadingLabel : children}
      </button>
    );
  },
);
Button.displayName = "Button";

export { buttonVariants };
