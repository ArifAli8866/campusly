"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useTransition } from "react";
import { ChevronDown, LogOut, Settings, ShieldCheck, User } from "lucide-react";
import { toast } from "sonner";

import { Avatar } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/overlays";
import { signOutAction } from "@/server/actions/auth";

export function AccountMenu({
  user,
}: {
  user: { displayName: string; username: string; avatarUrl: string | null; role: "user" | "moderator" | "admin" };
}) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();

  function signOut() {
    startTransition(async () => {
      const result = await signOutAction();
      if (!result.ok) {
        toast.error(result.error);
        return;
      }
      router.push("/");
      router.refresh();
    });
  }

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" size="sm" className="gap-1.5 px-1.5" aria-label="Account menu">
          <Avatar src={user.avatarUrl} name={user.displayName} size="sm" />
          <ChevronDown className="size-3.5 text-muted-foreground" aria-hidden />
        </Button>
      </DropdownMenuTrigger>

      <DropdownMenuContent align="end" className="w-56">
        <DropdownMenuLabel>
          <span className="block truncate text-[0.8125rem] font-medium text-foreground">{user.displayName}</span>
          <span className="block truncate text-xs font-normal text-muted-foreground">@{user.username}</span>
        </DropdownMenuLabel>
        <DropdownMenuSeparator />

        <DropdownMenuItem asChild>
          <Link href={`/u/${user.username}`}>
            <User /> My profile
          </Link>
        </DropdownMenuItem>
        <DropdownMenuItem asChild>
          <Link href="/settings/profile">
            <Settings /> Settings
          </Link>
        </DropdownMenuItem>
        {user.role !== "user" ? (
          <DropdownMenuItem asChild>
            <Link href="/moderation">
              <ShieldCheck /> Moderation queue
            </Link>
          </DropdownMenuItem>
        ) : null}
        {user.role === "admin" ? (
          <DropdownMenuItem asChild>
            <Link href="/admin">
              <ShieldCheck /> Admin dashboard
            </Link>
          </DropdownMenuItem>
        ) : null}

        <DropdownMenuSeparator />
        <DropdownMenuItem onSelect={signOut} disabled={isPending} className="text-danger focus:bg-danger-subtle focus:text-danger">
          <LogOut /> {isPending ? "Signing out…" : "Sign out"}
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
