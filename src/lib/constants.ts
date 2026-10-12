import type { PostCategory, ReportReason } from "@/lib/db/types";

export const POST_CATEGORIES: { value: PostCategory; label: string; description: string }[] = [
  { value: "general", label: "General", description: "Anything that does not fit elsewhere" },
  { value: "campus_life", label: "Campus life", description: "Events, societies, hostels, transport" },
  { value: "academics", label: "Academic life", description: "Courses, faculty, study tips" },
  { value: "exams", label: "Exams & assignments", description: "Deadlines, prep, results" },
  { value: "relationships", label: "Crushes & relationships", description: "The classic confession territory" },
  { value: "memes", label: "Funny campus moments", description: "Light-hearted campus humour" },
  { value: "career", label: "Career & internships", description: "Jobs, internships, grad school" },
  { value: "complaints", label: "Campus complaints", description: "Facilities, admin, fees" },
  { value: "advice", label: "Advice", description: "Ask the community for help" },
];

export const CATEGORY_LABEL: Record<PostCategory, string> = POST_CATEGORIES.reduce(
  (acc, category) => {
    acc[category.value] = category.label;
    return acc;
  },
  {} as Record<PostCategory, string>,
);

export const INTERESTS = [
  { value: "campus_life", label: "Campus life" },
  { value: "memes", label: "Memes" },
  { value: "academics", label: "Academics" },
  { value: "relationships", label: "Relationships" },
  { value: "career", label: "Career advice" },
  { value: "technology", label: "Technology" },
  { value: "sports", label: "Sports" },
  { value: "societies", label: "Societies & clubs" },
  { value: "hostel", label: "Hostel life" },
  { value: "startups", label: "Startups" },
  { value: "exams", label: "Exams" },
  { value: "music", label: "Music & arts" },
] as const;

export const REPORT_REASONS: { value: ReportReason; label: string; description: string }[] = [
  { value: "harassment", label: "Harassment", description: "Targeted, repeated unwanted contact" },
  { value: "bullying", label: "Bullying", description: "Mocking, excluding or intimidating someone" },
  { value: "threats", label: "Threats of violence", description: "Threatening harm to a person" },
  { value: "hate_speech", label: "Hate speech", description: "Attacking people for who they are" },
  { value: "impersonation", label: "Impersonation", description: "Pretending to be someone else" },
  { value: "spam", label: "Spam or scams", description: "Advertising, repeat posting, fraud" },
  { value: "private_information", label: "Sharing private information", description: "Phone numbers, addresses, CNIC, screenshots" },
  { value: "inappropriate_content", label: "Inappropriate content", description: "Sexual, graphic or disturbing material" },
  { value: "other", label: "Something else", description: "Tell us what is wrong" },
];

export const REPORT_REASON_LABEL: Record<ReportReason, string> = REPORT_REASONS.reduce(
  (acc, reason) => {
    acc[reason.value] = reason.label;
    return acc;
  },
  {} as Record<ReportReason, string>,
);

export const POST_MAX_LENGTH = 2000;
export const REPORT_DESCRIPTION_MAX = 1000;
export const POLL_QUESTION_MAX = 200;
export const POLL_OPTION_MAX = 120;
export const MIN_POLL_OPTIONS = 2;
export const MAX_POLL_OPTIONS = 6;
export const COMMENT_MAX_LENGTH = 1500;
export const BIO_MAX_LENGTH = 300;

/** Server-side rate limits. Enforced in the database, not in the UI. */
export const RATE_LIMITS = {
  post: { max: 8, windowSeconds: 900, label: "You have published a lot in the last 15 minutes. Try again shortly." },
  comment: { max: 25, windowSeconds: 900, label: "You have commented a lot in the last 15 minutes. Try again shortly." },
  report: { max: 10, windowSeconds: 3600, label: "You have sent a lot of reports recently. Our team is on it." },
  channelJoin: { max: 30, windowSeconds: 3600, label: "Too many community joins in a short time." },
  like: { max: 200, windowSeconds: 3600, label: "Slow down a moment." },
  pollVote: { max: 40, windowSeconds: 3600, label: "Too many poll votes in a short time." },
} as const;

export const FEED_PAGE_SIZE = 10;
export const COMMENT_PAGE_SIZE = 20;
export const PROVINCES = [
  "Punjab",
  "Sindh",
  "Khyber Pakhtunkhwa",
  "Balochistan",
  "Islamabad Capital Territory",
  "Gilgit-Baltistan",
  "Azad Jammu and Kashmir",
] as const;

export const INSTITUTION_TYPES = [
  { value: "public", label: "Public" },
  { value: "private", label: "Private" },
  { value: "semi_government", label: "Semi-government" },
  { value: "military", label: "Military" },
  { value: "unknown", label: "Not recorded" },
] as const;

export const UNIVERSITY_STATUS_LABEL = {
  active: "Active",
  pending_review: "Pending review",
  merged: "Merged",
  archived: "Archived",
} as const;

export const MODERATION_STATUS_LABEL = {
  published: "Published",
  under_review: "Under review",
  hidden: "Hidden",
  removed: "Removed",
} as const;
