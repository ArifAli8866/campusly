import type { Metadata } from "next";
import Link from "next/link";
import {
  AtSign,
  Bell,
  CheckCheck,
  Heart,
  MessageCircle,
  MessageSquare,
} from "lucide-react";

import { BRAND } from "@/components/brand";
import { Avatar, Card, EmptyState } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { PageHeader } from "@/components/layout/page-header";
import { relativeTime } from "@/lib/utils";
import { requireOnboarded } from "@/server/auth/context";
import { getNotifications } from "@/server/services/queries";
import { markAllNotificationsReadAction } from "@/server/actions/social";

export const metadata: Metadata = {
  title: `Notifications — ${BRAND.name}`,
  robots: { index: false, follow: false },
};

export const dynamic = "force-dynamic";

export default async function NotificationsPage() {
  const context = await requireOnboarded("/notifications");
  const scope = { db: context.db, userId: context.id };

  const notifications = await getNotifications(scope, 40);
  const unreadCount = notifications.filter((n) => !n.is_read).length;

  async function handleMarkAllRead() {
    "use server";
    await markAllNotificationsReadAction();
  }

  return (
    <div className="mx-auto w-full max-w-3xl px-4 py-6 sm:py-8">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <PageHeader
          title="Notifications"
          description={
            unreadCount > 0
              ? `You have ${unreadCount} unread notification${unreadCount === 1 ? "" : "s"}.`
              : "All caught up. You have no unread notifications."
          }
        />

        {unreadCount > 0 ? (
          <form action={handleMarkAllRead}>
            <Button type="submit" variant="outline" size="sm" className="gap-1.5">
              <CheckCheck className="size-3.5" /> Mark all as read
            </Button>
          </form>
        ) : null}
      </div>

      <div className="mt-6">
        {notifications.length > 0 ? (
          <div className="divide-y divide-border/60 overflow-hidden rounded-2xl border border-border bg-card shadow-[var(--shadow-soft)]">
            {notifications.map((n) => {
              const href = n.post_id ? `/p/${n.post_id}` : n.channel_slug ? `/channels/${n.channel_slug}` : "#";

              return (
                <Link
                  key={n.id}
                  href={href}
                  className={`flex items-start gap-3.5 p-4 transition-colors hover:bg-muted/50 ${
                    !n.is_read ? "bg-accent-subtle/30" : ""
                  }`}
                >
                  {/* Icon or Avatar */}
                  <div className="relative shrink-0">
                    <Avatar
                      src={n.actor_avatar_url}
                      name={n.actor_display_name ?? "Student"}
                      anonymous={!n.actor_username}
                      seed={n.actor_id ?? n.id}
                      size="md"
                    />
                    <span className="absolute -bottom-1 -right-1 flex size-5 items-center justify-center rounded-full bg-card shadow-xs">
                      {n.type === "mention_post" || n.type === "mention_comment" ? (
                        <AtSign className="size-3 text-accent" />
                      ) : n.type === "post_like" || n.type === "comment_like" ? (
                        <Heart className="size-3 text-danger fill-danger" />
                      ) : n.type === "reply_to_comment" ? (
                        <MessageSquare className="size-3 text-emerald-500" />
                      ) : (
                        <MessageCircle className="size-3 text-blue-500" />
                      )}
                    </span>
                  </div>

                  {/* Content */}
                  <div className="min-w-0 flex-1">
                    <p className="text-sm text-foreground">
                      <strong className="font-semibold">
                        {n.actor_display_name || (n.actor_username ? `@${n.actor_username}` : "Someone")}
                      </strong>{" "}
                      {n.type === "mention_post" || n.type === "mention_comment" ? (
                        "mentioned you"
                      ) : n.type === "post_like" || n.type === "comment_like" ? (
                        "liked your confession"
                      ) : n.type === "reply_to_comment" ? (
                        "replied to your comment"
                      ) : n.type === "comment_on_post" ? (
                        "commented on your confession"
                      ) : (
                        "shared an update"
                      )}
                      {n.channel_name ? (
                        <span className="text-muted-foreground"> in {n.channel_name}</span>
                      ) : null}
                    </p>

                    {n.comment_excerpt || n.post_excerpt ? (
                      <p className="mt-1 line-clamp-2 text-xs text-muted-foreground italic">
                        &ldquo;{n.comment_excerpt || n.post_excerpt}&rdquo;
                      </p>
                    ) : null}

                    <p className="mt-1.5 text-[0.6875rem] text-muted-foreground">
                      {relativeTime(n.created_at)}
                    </p>
                  </div>

                  {!n.is_read ? (
                    <span className="size-2 rounded-full bg-accent mt-2 shrink-0" aria-label="Unread" />
                  ) : null}
                </Link>
              );
            })}
          </div>
        ) : (
          <Card className="p-10 text-center">
            <EmptyState
              icon={Bell}
              title="No notifications yet"
              description="When someone likes, comments, or mentions you on campus discussions, you'll see alerts here."
            />
          </Card>
        )}
      </div>
    </div>
  );
}
