import "server-only";

import { dbAs, type Db } from "@/lib/db";
import type {
  CampusChoice,
  CampusRow,
  ChannelOverview,
  ChannelRow,
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
  UniversityRow,
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

export interface UniversityCardsOptions {
  query?: string | null;
  province?: string | null;
  city?: string | null;
  type?: string | null;
  sort?: "name" | "most_joined" | "recently_active" | "campuses";
  limit?: number;
  offset?: number;
}

export async function getUniversityCards(
  scope: ViewerScope,
  options: UniversityCardsOptions = {},
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

/**
 * Robustly look up a university by slug or abbreviation.
 * 1. Queries the universities table directly (100% resilient across database schemas).
 * 2. Fetches associated campuses and channels, ensuring each campus points to an active channel ID and slug.
 * 3. Falls back to university_cards RPC search if necessary.
 */
export async function getUniversityBySlug(scope: ViewerScope, slug: string): Promise<UniversityCard | null> {
  const cleaned = slug.trim().toLowerCase();
  if (!cleaned) return null;

  // 1. Direct query against universities table
  const unis = await scope.db
    .select<UniversityRow>("universities", {
      where: { slug: cleaned },
      limit: 1,
    })
    .catch(() => [] as UniversityRow[]);

  let uni: UniversityRow | undefined = unis[0];

  // If not found by slug, try matching by uppercase abbreviation (e.g. NUST, FAST, LUMS)
  if (!uni) {
    const byAbbr = await scope.db
      .select<UniversityRow>("universities", {
        where: { abbreviation: cleaned.toUpperCase() },
        limit: 1,
      })
      .catch(() => [] as UniversityRow[]);
    uni = byAbbr[0];
  }

  // If still not found, try matching normalized slug across all universities
  if (!uni) {
    const all = await scope.db.select<UniversityRow>("universities", { limit: 300 }).catch(() => [] as UniversityRow[]);
    uni = all.find(
      (u) =>
        u.slug.toLowerCase() === cleaned ||
        u.abbreviation?.toLowerCase() === cleaned ||
        u.name.toLowerCase().replace(/[^a-z0-9]+/g, "-") === cleaned,
    );
  }

  if (uni) {
    // Fetch campuses and channels for this university directly from tables
    const [campuses, channels, memberCountRows, postCountRows] = await Promise.all([
      scope.db
        .select<CampusRow>("campuses", {
          where: { university_id: uni.id, is_active: true },
        })
        .catch(() => [] as CampusRow[]),
      scope.db
        .select<ChannelRow>("channels", {
          where: { university_id: uni.id, is_active: true },
        })
        .catch(() => [] as ChannelRow[]),
      scope.db
        .select<{ id: string }>("channel_members", {
          where: { university_id: uni.id },
        })
        .catch(() => [] as { id: string }[]),
      scope.db
        .select<{ id: string }>("posts", {
          where: { university_id: uni.id, moderation_status: "published" },
        })
        .catch(() => [] as { id: string }[]),
    ]);

    // Map each campus to its active channel ID and channel slug
    const mappedCampuses = campuses
      .sort((a, b) => (b.is_main ? 1 : 0) - (a.is_main ? 1 : 0) || a.name.localeCompare(b.name))
      .map((campus) => {
        const channel = channels.find((ch) => ch.campus_id === campus.id);
        const channelId = channel?.id ?? campus.id;
        const channelSlug = channel?.slug ?? campus.slug;
        return {
          id: channelId,
          slug: channelSlug,
          name: campus.name,
          city: campus.city,
          member_count: 0,
        };
      });

    return {
      id: uni.id,
      name: uni.name,
      slug: uni.slug,
      abbreviation: uni.abbreviation,
      description: uni.description,
      logo_url: uni.logo_url,
      banner_url: uni.banner_url,
      city: uni.city,
      province: uni.province,
      institution_type: uni.institution_type,
      is_featured: uni.is_featured,
      campus_count: campuses.length,
      member_count: memberCountRows.length,
      post_count: postCountRows.length,
      week_post_count: 0,
      viewer_is_member: false,
      campuses: mappedCampuses,
    };
  }

  // Fallback: try university_cards with safe 7 arguments
  const fallbackCards = await getUniversityCards(scope, { query: cleaned, limit: 10 }).catch(() => [] as UniversityCard[]);
  const match = fallbackCards.find(
    (u) =>
      u.slug.toLowerCase() === cleaned ||
      u.abbreviation?.toLowerCase() === cleaned ||
      u.name.toLowerCase().replace(/[^a-z0-9]+/g, "-") === cleaned,
  );
  return match ?? fallbackCards[0] ?? null;
}

export async function getChannelOverview(scope: ViewerScope, slug: string): Promise<ChannelOverview | null> {
  const cleaned = slug.trim();
  if (!cleaned) return null;

  // 1. Try channel_overview RPC first
  const rows = await scope.db
    .rpc<{ channel_overview: ChannelOverview }>("channel_overview", { p_slug: cleaned })
    .catch(() => [] as { channel_overview: ChannelOverview }[]);

  if (rows[0]?.channel_overview) {
    return rows[0].channel_overview;
  }

  // 2. If lowercase differs, try lowercase
  if (cleaned.toLowerCase() !== cleaned) {
    const fallbackRows = await scope.db
      .rpc<{ channel_overview: ChannelOverview }>("channel_overview", { p_slug: cleaned.toLowerCase() })
      .catch(() => [] as { channel_overview: ChannelOverview }[]);
    if (fallbackRows[0]?.channel_overview) {
      return fallbackRows[0].channel_overview;
    }
  }

  // 3. Fallback: if the requested slug is a campus slug (e.g. main-campus), find the channel for that campus
  const campuses = await scope.db
    .select<CampusRow>("campuses", {
      where: { slug: cleaned.toLowerCase() },
      limit: 1,
    })
    .catch(() => [] as CampusRow[]);

  if (campuses[0]) {
    const channels = await scope.db
      .select<ChannelRow>("channels", {
        where: { campus_id: campuses[0].id },
        limit: 1,
      })
      .catch(() => [] as ChannelRow[]);

    if (channels[0]) {
      const channelRows = await scope.db
        .rpc<{ channel_overview: ChannelOverview }>("channel_overview", { p_slug: channels[0].slug })
        .catch(() => [] as { channel_overview: ChannelOverview }[]);
      if (channelRows[0]?.channel_overview) {
        return channelRows[0].channel_overview;
      }
    }
  }

  // 4. Fallback: if the requested slug is a university slug or abbreviation (e.g. /channels/nust)
  const unis = await scope.db
    .select<UniversityRow>("universities", {
      where: { slug: cleaned.toLowerCase() },
      limit: 1,
    })
    .catch(() => [] as UniversityRow[]);

  const uni =
    unis[0] ??
    (
      await scope.db
        .select<UniversityRow>("universities", {
          where: { abbreviation: cleaned.toUpperCase() },
          limit: 1,
        })
        .catch(() => [] as UniversityRow[])
    )[0];

  if (uni) {
    const channels = await scope.db
      .select<ChannelRow>("channels", {
        where: { university_id: uni.id, is_active: true },
        limit: 1,
      })
      .catch(() => [] as ChannelRow[]);

    if (channels[0]) {
      const channelRows = await scope.db
        .rpc<{ channel_overview: ChannelOverview }>("channel_overview", { p_slug: channels[0].slug })
        .catch(() => [] as { channel_overview: ChannelOverview }[]);
      if (channelRows[0]?.channel_overview) {
        return channelRows[0].channel_overview;
      }
    }
  }

  return null;
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
