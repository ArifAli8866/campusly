import "server-only";

import { dbAs, type Db } from "@/lib/db";
import type {
  ChannelOverview,
  CommentView,
  DiscoveredUser,
  ModerationQueueItem,
  MyChannel,
  NotificationView,
  PlatformStats,
  PostView,
  ProfilePublicView,
  RecommendedChannel,
  SavedPostView,
  SearchResults,
  TrendingTopic,
  UniversityCard,
  UniversityChoice,
  CampusChoice,
} from "@/lib/db/types";
import { getSessionUser } from "@/server/auth/session";

/**
 * Read layer.
 *
 * Everything here calls a Postgres function rather than issuing ad-hoc table
 * queries, for two reasons:
 *   1. The functions are the only place that knows how to null an anonymous
 *      author, so no page can accidentally bypass that.
 *   2. Counts (members, posts, likes) are computed in the database from real
 *      rows — never from client-side arrays or hardcoded numbers.
 */

export interface ViewerScope {
  db: Db;
  userId: string | null;
}

/** Handle for the current request: signed-in user, or anonymous. */
export async function viewerScope(): Promise<ViewerScope> {
  const session = await getSessionUser();
  return { db: await dbAs(session?.id ?? null), userId: session?.id ?? null };
}

/* ------------------------------------------------------------------- feeds */

export interface FeedOptions {
  channelId?: string | null;
  sort?: "latest" | "trending" | "most_liked" | "following" | "mentioned";
  cursor?: string | null;
  cursorId?: string | null;
  offset?: number;
  limit?: number;
  category?: string | null;
  search?: string | null;
  followingOnly?: boolean;
}

export async function getFeed(scope: ViewerScope, options: FeedOptions = {}): Promise<PostView[]> {
  return scope.db.rpc<PostView>("feed_posts", {
    p_channel_id: options.channelId ?? null,
    p_sort: options.sort ?? "latest",
    p_cursor: options.cursor ?? null,
    p_cursor_id: options.cursorId ?? null,
    p_offset: options.offset ?? 0,
    p_limit: options.limit ?? 10,
    p_category: options.category ?? null,
    p_search: options.search ?? null,
    p_following_only: options.followingOnly ?? false,
  });
}

export async function getPost(scope: ViewerScope, postId: string): Promise<(PostView & { deleted_at: string | null }) | null> {
  const rows = await scope.db.rpc<PostView & { deleted_at: string | null }>("get_post", { p_post_id: postId });
  return rows[0] ?? null;
}

export async function getComments(
  scope: ViewerScope,
  postId: string,
  options: { cursor?: string | null; cursorId?: string | null; limit?: number } = {},
): Promise<CommentView[]> {
  return scope.db.rpc<CommentView>("post_comments", {
    p_post_id: postId,
    p_cursor: options.cursor ?? null,
    p_cursor_id: options.cursorId ?? null,
    p_limit: options.limit ?? 20,
  });
}

export async function getReplies(scope: ViewerScope, rootId: string, limit = 50): Promise<CommentView[]> {
  return scope.db.rpc<CommentView>("comment_replies", { p_root_id: rootId, p_limit: limit });
}

export async function getWeeklyHighlights(scope: ViewerScope, limit = 4): Promise<PostView[]> {
  return scope.db.rpc<PostView>("weekly_highlights", { p_limit: limit });
}

export async function getTrendingTopics(
  scope: ViewerScope,
  options: { channelId?: string | null; universityId?: string | null; limit?: number; days?: number } = {},
): Promise<TrendingTopic[]> {
  return scope.db.rpc<TrendingTopic>("trending_topics", {
    p_channel_id: options.channelId ?? null,
    p_university_id: options.universityId ?? null,
    p_limit: options.limit ?? 8,
    p_days: options.days ?? 14,
  });
}

/* -------------------------------------------------------------- universities */

export async function getUniversityCards(
  scope: ViewerScope,
  options: {
    query?: string | null;
    province?: string | null;
    city?: string | null;
    type?: string | null;
    sort?: "name" | "most_joined" | "recently_active" | "campuses";
    limit?: number;
    offset?: number;
  } = {},
): Promise<UniversityCard[]> {
  return scope.db.rpc<UniversityCard>("university_cards", {
    p_query: options.query ?? null,
    p_province: options.province ?? null,
    p_city: options.city ?? null,
    p_type: options.type ?? null,
    p_sort: options.sort ?? "name",
    p_limit: options.limit ?? 24,
    p_offset: options.offset ?? 0,
  });
}

export async function getChannelOverview(scope: ViewerScope, slug: string): Promise<ChannelOverview | null> {
  const rows = await scope.db.rpc<{ channel_overview: ChannelOverview }>("channel_overview", { p_slug: slug });
  return rows[0]?.channel_overview ?? null;
}

export async function getMyChannels(scope: ViewerScope, limit = 60): Promise<MyChannel[]> {
  if (!scope.userId) return [];
  return scope.db.rpc<MyChannel>("my_channels", { p_limit: limit });
}

export async function getRecommendedChannels(scope: ViewerScope, limit = 8): Promise<RecommendedChannel[]> {
  if (!scope.userId) return [];
  return scope.db.rpc<RecommendedChannel>("recommended_channels", { p_limit: limit });
}

export async function getUniversityChoices(scope: ViewerScope, query?: string, limit = 20): Promise<UniversityChoice[]> {
  return scope.db.rpc<UniversityChoice>("university_choices", { p_query: query ?? null, p_limit: limit });
}

export async function getCampusChoices(scope: ViewerScope, universityId: string, query?: string): Promise<CampusChoice[]> {
  return scope.db.rpc<CampusChoice>("campus_choices", {
    p_university_id: universityId,
    p_query: query ?? null,
    p_limit: 40,
  });
}

/* ------------------------------------------------------------------ profiles */

export async function getPublicProfile(scope: ViewerScope, username: string): Promise<ProfilePublicView | null> {
  const rows = await scope.db.rpc<ProfilePublicView>("profile_public", { p_username: username });
  return rows[0] ?? null;
}

export async function getProfilePosts(
  scope: ViewerScope,
  profileId: string,
  options: { cursor?: string | null; cursorId?: string | null; limit?: number } = {},
): Promise<PostView[]> {
  return scope.db.rpc<PostView>("profile_posts", {
    p_profile_id: profileId,
    p_cursor: options.cursor ?? null,
    p_cursor_id: options.cursorId ?? null,
    p_limit: options.limit ?? 10,
  });
}

/**
 * The owner-only list of their own anonymous confessions.
 * Never call this with anyone else's id — the RPC filters on auth.uid().
 */
export async function getMyConfessions(
  scope: ViewerScope,
  options: { limit?: number } = {},
): Promise<PostView[]> {
  if (!scope.userId) return [];
  return scope.db.rpc<PostView>("my_confessions", { p_limit: options.limit ?? 20 });
}

export async function getDiscoverableUsers(
  scope: ViewerScope,
  options: { universityId?: string | null; query?: string | null; limit?: number; offset?: number } = {},
): Promise<DiscoveredUser[]> {
  return scope.db.rpc<DiscoveredUser>("discover_users", {
    p_university_id: options.universityId ?? null,
    p_query: options.query ?? null,
    p_limit: options.limit ?? 12,
    p_offset: options.offset ?? 0,
  });
}

/* ------------------------------------------------------------------- search */

export async function runSearch(
  scope: ViewerScope,
  query: string,
  scopeType: "all" | "universities" | "campuses" | "users" | "posts" = "all",
  limit = 12,
  offset = 0,
): Promise<SearchResults> {
  const rows = await scope.db.rpc<{ search_all: SearchResults }>("search_all", {
    p_query: query,
    p_scope: scopeType,
    p_limit: limit,
    p_offset: offset,
  });

  return (
    rows[0]?.search_all ?? {
      query,
      universities: [],
      campuses: [],
      users: [],
      posts: [],
    }
  );
}

/* ---------------------------------------------------------- notifications etc */

export async function getNotifications(scope: ViewerScope, limit = 25, offset = 0): Promise<NotificationView[]> {
  if (!scope.userId) return [];
  return scope.db.rpc<NotificationView>("notification_feed", { p_limit: limit, p_offset: offset });
}

export async function getSavedPosts(scope: ViewerScope, limit = 20, offset = 0): Promise<SavedPostView[]> {
  if (!scope.userId) return [];
  return scope.db.rpc<SavedPostView>("saved_posts_feed", { p_limit: limit, p_offset: offset });
}

/* -------------------------------------------------------------- moderation */

export async function getModerationQueue(
  scope: ViewerScope,
  status: "open" | "in_review" | "resolved" | "dismissed" = "open",
  limit = 30,
  offset = 0,
): Promise<ModerationQueueItem[]> {
  return scope.db.rpc<ModerationQueueItem>("moderation_queue", {
    p_status: status,
    p_limit: limit,
    p_offset: offset,
  });
}

export async function getPlatformStats(scope: ViewerScope): Promise<PlatformStats | null> {
  const rows = await scope.db.rpc<{ platform_stats: PlatformStats }>("platform_stats");
  return rows[0]?.platform_stats ?? null;
}

/* ------------------------------------------------------------------ catalogue */

export interface CatalogueCounts {
  universities: number;
  campuses: number;
  channels: number;
  provinces: number;
  cities: number;
}

/**
 * Live catalogue size. The landing page and onboarding display these instead of
 * any hardcoded "N+ universities" figure, so the number can never drift from
 * what is actually in the database.
 */
export async function getCatalogueCounts(scope: ViewerScope): Promise<CatalogueCounts> {
  const rows = await scope.db.rpc<{ catalogue_counts: CatalogueCounts }>("catalogue_counts");
  return (
    rows[0]?.catalogue_counts ?? { universities: 0, campuses: 0, channels: 0, provinces: 0, cities: 0 }
  );
}

/* ------------------------------------------------------------------ mentions */

/**
 * Mention rendering map.
 *
 * `flat` is suitable for a feed where every card can share one handle map;
 * `bySource` is used where a page renders a specific post and its comments.
 * Both come from stored mention rows, so a deleted account's handle stops
 * resolving instead of pointing at a recycled username.
 */
export async function getMentionMaps(
  scope: ViewerScope,
  options: { postIds?: string[]; commentIds?: string[] } = {},
): Promise<{ flat: Record<string, string>; bySource: Record<string, Record<string, string>> }> {
  const postIds = options.postIds ?? [];
  const commentIds = options.commentIds ?? [];
  if (postIds.length === 0 && commentIds.length === 0) return { flat: {}, bySource: {} };

  const rows = await scope.db.rpc<{ source_id: string; handle: string; username: string }>(
    "resolve_post_mentions",
    { p_post_ids: postIds, p_comment_ids: commentIds },
  );

  const bySource: Record<string, Record<string, string>> = {};
  const flat: Record<string, string> = {};

  for (const row of rows) {
    bySource[row.source_id] ??= {};
    bySource[row.source_id]![row.handle] = row.username;
    flat[row.handle] = row.username;
  }

  return { flat, bySource };
}
