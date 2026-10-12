/**
 * Database types.
 *
 * These mirror supabase/migrations/*.sql. On a live Supabase project they can be
 * regenerated with `npm run db:types` (supabase gen types typescript), which
 * overwrites this file — so keep hand-written helpers in ./models.ts instead.
 */

export type AppRole = "user" | "moderator" | "admin";
export type ProfileVisibility = "public" | "university" | "private";
export type InstitutionType = "public" | "private" | "semi_government" | "military" | "unknown";
export type UniversityStatus = "active" | "pending_review" | "merged" | "archived";
export type ModerationStatus = "published" | "under_review" | "hidden" | "removed";
export type MentionSource = "post" | "comment";
export type NotificationType =
  | "mention_post"
  | "mention_comment"
  | "comment_on_post"
  | "reply_to_comment"
  | "post_like"
  | "comment_like"
  | "channel_join"
  | "moderation_action"
  | "welcome";
export type ReportTarget = "post" | "comment" | "user";
export type ReportReason =
  | "harassment"
  | "bullying"
  | "threats"
  | "hate_speech"
  | "impersonation"
  | "spam"
  | "private_information"
  | "inappropriate_content"
  | "other";
export type ReportStatus = "open" | "in_review" | "resolved" | "dismissed";
export type ModerationActionType =
  | "content_hidden"
  | "content_restored"
  | "content_removed"
  | "user_suspended"
  | "user_reinstated"
  | "user_warned"
  | "report_resolved"
  | "report_dismissed"
  | "identity_disclosed";
export type PostCategory =
  | "general"
  | "campus_life"
  | "academics"
  | "exams"
  | "relationships"
  | "memes"
  | "career"
  | "complaints"
  | "advice";

export interface UniversityRow {
  id: string;
  name: string;
  normalized_name: string;
  slug: string;
  abbreviation: string | null;
  aliases: string[];
  description: string | null;
  logo_url: string | null;
  banner_url: string | null;
  city: string | null;
  province: string | null;
  institution_type: InstitutionType;
  is_featured: boolean;
  status: UniversityStatus;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface CampusRow {
  id: string;
  university_id: string;
  name: string;
  slug: string;
  city: string | null;
  province: string | null;
  address: string | null;
  is_main: boolean;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface ChannelRow {
  id: string;
  university_id: string;
  campus_id: string;
  slug: string;
  name: string;
  description: string | null;
  banner_url: string | null;
  guidelines: string | null;
  posting_policy: "members" | "anyone_authenticated" | "moderators_only";
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface ProfileRow {
  id: string;
  username: string;
  display_name: string;
  avatar_url: string | null;
  banner_url: string | null;
  bio: string | null;
  university_id: string | null;
  campus_id: string | null;
  country: string;
  degree_program: string | null;
  department: string | null;
  semester: string | null;
  graduation_year: number | null;
  interests: string[];
  profile_visibility: ProfileVisibility;
  onboarding_step: number;
  onboarding_completed: boolean;
  username_changed_at: string | null;
  is_suspended: boolean;
  suspended_reason: string | null;
  last_active_at: string;
  created_at: string;
  updated_at: string;
}

export interface ChannelMemberRow {
  id: string;
  user_id: string;
  channel_id: string;
  university_id: string;
  role: "member" | "moderator";
  is_muted: boolean;
  joined_at: string;
}

export interface PostRow {
  id: string;
  channel_id: string;
  university_id: string;
  body: string;
  is_anonymous: boolean;
  category: PostCategory | null;
  media_path: string | null;
  media_width: number | null;
  media_height: number | null;
  moderation_status: ModerationStatus;
  like_count: number;
  comment_count: number;
  share_count: number;
  is_pinned: boolean;
  edited_at: string | null;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
}

export interface CommentRow {
  id: string;
  post_id: string;
  parent_id: string | null;
  root_id: string | null;
  depth: number;
  body: string;
  is_anonymous: boolean;
  moderation_status: ModerationStatus;
  like_count: number;
  reply_count: number;
  edited_at: string | null;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
}

export interface DraftRow {
  id: string;
  user_id: string;
  channel_id: string | null;
  body: string;
  is_anonymous: boolean;
  category: PostCategory | null;
  media_path: string | null;
  created_at: string;
  updated_at: string;
}

export interface NotificationRow {
  id: string;
  recipient_id: string;
  actor_id: string | null;
  type: NotificationType;
  post_id: string | null;
  comment_id: string | null;
  channel_id: string | null;
  body_preview: string | null;
  is_read: boolean;
  created_at: string;
}

export interface NotificationPreferenceRow {
  user_id: string;
  mentions: boolean;
  comments: boolean;
  replies: boolean;
  likes: boolean;
  channel_activity: boolean;
  product_updates: boolean;
  updated_at: string;
}

export interface ReportRow {
  id: string;
  reporter_id: string;
  target_type: ReportTarget;
  target_id: string;
  target_snapshot: Record<string, unknown> | null;
  reason: ReportReason;
  description: string | null;
  status: ReportStatus;
  priority: number;
  reviewed_by: string | null;
  reviewed_at: string | null;
  resolution_note: string | null;
  created_at: string;
  updated_at: string;
}

export interface AuditLogRow {
  id: number;
  actor_id: string | null;
  actor_role: AppRole | null;
  event: string;
  target_type: string | null;
  target_id: string | null;
  metadata: Record<string, unknown>;
  created_at: string;
}

export interface UserRoleRow {
  user_id: string;
  role: AppRole;
  granted_by: string | null;
  granted_at: string;
}

/* ------------------------------------------------------------------ RPC shapes */

export interface PollOptionView {
  id: string;
  label: string;
  votes: number;
  voted: boolean;
}

export interface PollView {
  id: string;
  question: string;
  allow_multiple: boolean;
  closes_at: string | null;
  total: number;
  options: PollOptionView[];
}

/**
 * The public shape of a post as returned by public.feed_posts() / get_post().
 * `author_id`, `author_username`, `author_display_name` and `author_avatar_url`
 * are NULL for an anonymous confession unless the viewer is the author.
 */
export interface PostView {
  id: string;
  channel_id: string;
  channel_slug: string;
  channel_name: string;
  campus_name: string;
  university_id: string;
  university_name: string;
  university_abbreviation: string | null;
  university_slug: string;
  city: string | null;
  body: string;
  is_anonymous: boolean;
  category: PostCategory | null;
  media_path: string | null;
  media_width: number | null;
  media_height: number | null;
  moderation_status: ModerationStatus;
  like_count: number;
  comment_count: number;
  share_count: number;
  is_pinned: boolean;
  edited_at: string | null;
  created_at: string;
  author_id: string | null;
  author_username: string | null;
  author_display_name: string | null;
  author_avatar_url: string | null;
  viewer_has_liked: boolean;
  viewer_has_saved: boolean;
  viewer_can_manage: boolean;
  poll: PollView | null;
  /** only present on the single-post lookup */
  deleted_at?: string | null;
}

export interface CommentView {
  id: string;
  post_id: string;
  parent_id: string | null;
  root_id: string | null;
  depth: number;
  body: string;
  is_anonymous: boolean;
  like_count: number;
  reply_count: number;
  edited_at: string | null;
  created_at: string;
  moderation_status: ModerationStatus;
  author_id: string | null;
  author_username: string | null;
  author_display_name: string | null;
  author_avatar_url: string | null;
  viewer_has_liked: boolean;
  viewer_can_manage: boolean;
  deleted_at: string | null;
}

export interface ProfilePublicView {
  id: string;
  username: string;
  display_name: string;
  avatar_url: string | null;
  banner_url: string | null;
  bio: string | null;
  university_id: string | null;
  university_name: string | null;
  university_abbreviation: string | null;
  university_slug: string | null;
  campus_id: string | null;
  campus_name: string | null;
  city: string | null;
  province: string | null;
  degree_program: string | null;
  department: string | null;
  semester: string | null;
  graduation_year: number | null;
  interests: string[];
  profile_visibility: ProfileVisibility;
  is_suspended: boolean;
  created_at: string;
  channels_joined: number;
  public_post_count: number;
  viewer_is_owner: boolean;
  viewer_is_blocking: boolean;
  viewer_is_blocked: boolean;
}

export interface ChannelOverview {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  banner_url: string | null;
  guidelines: string | null;
  posting_policy: "members" | "anyone_authenticated" | "moderators_only";
  is_active: boolean;
  university_id: string;
  university_name: string;
  university_slug: string;
  university_abbreviation: string | null;
  university_logo_url: string | null;
  university_banner_url: string | null;
  university_description: string | null;
  university_city: string | null;
  university_province: string | null;
  university_type: InstitutionType;
  campus_id: string;
  campus_name: string;
  campus_city: string | null;
  campus_province: string | null;
  member_count: number;
  post_count: number;
  today_post_count: number;
  week_post_count: number;
  is_member: boolean;
  is_muted: boolean;
  other_campuses: Array<{ id: string; slug: string; campus_name: string; city: string | null; member_count: number }>;
}

export interface UniversityCard {
  id: string;
  name: string;
  slug: string;
  abbreviation: string | null;
  description: string | null;
  logo_url: string | null;
  banner_url: string | null;
  city: string | null;
  province: string | null;
  institution_type: InstitutionType;
  is_featured: boolean;
  campus_count: number;
  member_count: number;
  post_count: number;
  week_post_count: number;
  viewer_is_member: boolean;
  campuses: Array<{ id: string; slug: string; name: string; city: string | null; member_count: number }>;
}

export interface MyChannel {
  channel_id: string;
  channel_slug: string;
  channel_name: string;
  description: string | null;
  banner_url: string | null;
  university_id: string;
  university_name: string;
  university_slug: string;
  university_abbreviation: string | null;
  university_logo_url: string | null;
  campus_name: string;
  city: string | null;
  province: string | null;
  member_count: number;
  post_count: number;
  week_post_count: number;
  is_muted: boolean;
  joined_at: string;
}

export interface RecommendedChannel {
  channel_id: string;
  channel_slug: string;
  channel_name: string;
  description: string | null;
  banner_url: string | null;
  university_id: string;
  university_name: string;
  university_slug: string;
  university_abbreviation: string | null;
  university_logo_url: string | null;
  campus_name: string;
  city: string | null;
  province: string | null;
  member_count: number;
  post_count: number;
  week_post_count: number;
  is_member: boolean;
  reason: string;
}

export interface NotificationView {
  id: string;
  type: NotificationType;
  is_read: boolean;
  created_at: string;
  actor_id: string | null;
  actor_username: string | null;
  actor_display_name: string | null;
  actor_avatar_url: string | null;
  post_id: string | null;
  post_is_anonymous: boolean | null;
  post_channel_slug: string | null;
  post_excerpt: string | null;
  comment_id: string | null;
  comment_excerpt: string | null;
  channel_id: string | null;
  channel_slug: string | null;
  channel_name: string | null;
}

export interface SearchResults {
  query: string;
  universities: Array<{
    id: string;
    name: string;
    slug: string;
    abbreviation: string | null;
    city: string | null;
    province: string | null;
    logo_url: string | null;
    banner_url: string | null;
    description: string | null;
    type: InstitutionType;
    campus_count: number;
    member_count: number;
    post_count: number;
  }>;
  campuses: Array<{
    id: string;
    name: string;
    slug: string;
    city: string | null;
    province: string | null;
    university_id: string;
    university_name: string;
    university_abbreviation: string | null;
    university_slug: string;
    logo_url: string | null;
    channel_slug: string | null;
    member_count: number;
    post_count: number;
  }>;
  users: Array<{
    id: string;
    username: string;
    display_name: string;
    avatar_url: string | null;
    bio: string | null;
    university_name: string | null;
    university_abbreviation: string | null;
    campus_name: string | null;
    visibility: ProfileVisibility;
  }>;
  posts: Array<{
    id: string;
    body: string;
    created_at: string;
    is_anonymous: boolean;
    like_count: number;
    comment_count: number;
    author_username: string | null;
    author_display_name: string | null;
    author_avatar_url: string | null;
    channel_slug: string;
    channel_name: string;
    university_abbreviation: string | null;
  }>;
}

export interface PlatformStats {
  total_users: number;
  onboarded_users: number;
  new_users_7d: number;
  active_users_7d: number;
  active_users_30d: number;
  suspended_users: number;
  universities: number;
  universities_pending: number;
  campuses: number;
  channels: number;
  memberships: number;
  posts_total: number;
  posts_7d: number;
  posts_anonymous: number;
  posts_hidden: number;
  comments_total: number;
  likes_total: number;
  reports_open: number;
  reports_in_review: number;
  reports_resolved_7d: number;
  moderators: number;
}

export interface ModerationQueueItem {
  report_id: string;
  target_type: ReportTarget;
  target_id: string;
  reason: ReportReason;
  description: string | null;
  status: ReportStatus;
  created_at: string;
  reporter_username: string | null;
  report_count: number;
  reviewed_by_username: string | null;
  reviewed_at: string | null;
  resolution_note: string | null;
  target_snapshot: Record<string, unknown> | null;
  snapshot_post_id: string | null;
  snapshot_channel_slug: string | null;
}

export interface SavedPostView extends PostView {
  saved_at: string;
}

export interface TrendingTopic {
  topic: string;
  post_count: number;
  engagement: number;
  latest_at: string;
}

export interface DiscoveredUser {
  id: string;
  username: string;
  display_name: string;
  avatar_url: string | null;
  bio: string | null;
  university_name: string | null;
  university_abbreviation: string | null;
  campus_name: string | null;
  channels_joined: number;
  created_at: string;
}

export interface UniversityChoice {
  id: string;
  name: string;
  abbreviation: string | null;
  slug: string;
  city: string | null;
  province: string | null;
  campus_count: number;
}

export interface CampusChoice {
  id: string;
  name: string;
  city: string | null;
  province: string | null;
  is_main: boolean;
}
