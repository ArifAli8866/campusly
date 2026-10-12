"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";
import { Check, Plus } from "lucide-react";
import { toast } from "sonner";

import { Button, type ButtonProps } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { joinChannelAction, leaveChannelAction } from "@/server/actions/channels";

/**
 * Join / leave control.
 *
 * The real guarantee against duplicate memberships lives in Postgres (a unique
 * index on `channel_members(user_id, channel_id)`), so this component can stay
 * optimistic without being able to corrupt anything: a re-join is reported as
 * success, and `isMember` is reconciled from the server response.
 */
export function JoinButton({
  channelId,
  channelSlug,
  isMember,
  signedIn,
  size = "md",
  variant,
  className,
  onChange,
}: {
  channelId: string | null;
  channelSlug: string | null;
  isMember: boolean;
  signedIn: boolean;
  size?: ButtonProps["size"];
  variant?: ButtonProps["variant"];
  className?: string;
  onChange?: (joined: boolean) => void;
}) {
  const router = useRouter();
  const [joined, setJoined] = useState(isMember);
  const [isPending, startTransition] = useTransition();

  if (!signedIn) {
    return (
      <Button asChild variant={variant ?? "outline"} size={size} className={className}>
        <Link href={channelSlug ? `/login?next=/channels/${channelSlug}` : "/login"}>Sign in to join</Link>
      </Button>
    );
  }

  if (!channelId) {
    return (
      <Button variant="outline" size={size} disabled className={className} title="No active campus community yet">
        Unavailable
      </Button>
    );
  }

  function toggle() {
    const next = !joined;
    setJoined(next);

    startTransition(async () => {
      const result = next ? await joinChannelAction(channelId!) : await leaveChannelAction(channelId!);

      if (!result.ok) {
        setJoined(!next);
        toast.error(result.error);
        return;
      }

      const settled = result.data?.joined ?? next;
      setJoined(settled);
      onChange?.(settled);
      if (result.message) toast.success(result.message);
      router.refresh();
    });
  }

  return (
    <Button
      variant={joined ? "outline" : (variant ?? "primary")}
      size={size}
      onClick={toggle}
      disabled={isPending}
      aria-pressed={joined}
      className={cn(className)}
    >
      {joined ? <Check /> : <Plus />}
      {joined ? "Joined" : "Join"}
    </Button>
  );
}
