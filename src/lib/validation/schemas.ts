/**
 * Every write in the app is parsed through one of these before it reaches the
 * database. Three rules hold throughout:
 *
 *   1. Nothing is trusted because the interface would not normally send it.
 *   2. No schema accepts an identity or authorisation field — `author_id`,
 *      `user_id` and `role` always come from the server session, so a crafted
 *      request cannot post as somebody else or promote itself.
 *   3. Empty strings from a form become `null` rather than being written as "".
 *
 * Parsing happens server-side only (server actions and route handlers).
 */
import { z } from "zod";

import {
  COMMENT_MAX_LENGTH,
  MAX_POLL_OPTIONS,
  MIN_POLL_OPTIONS,
  POLL_OPTION_MAX,
  POLL_QUESTION_MAX,
  POST_MAX_LENGTH,
  REPORT_DESCRIPTION_MAX,
} from "@/lib/constants";

/* ----------------------------------------------------------------- primitives */

export const uuid = z.string().uuid("That does not look like a valid identifier.");

/** An optional form field: "" → null, absent → null, otherwise trimmed text. */
const optionalText = (max: number) =>
  z
    .preprocess((value) => (value === "" || value === undefined ? null : value), z.string().trim().max(max).nullable())
    .nullable();

const optionalUuid = z.preprocess(
  (value) => (value === "" || value === undefined ? null : value),
  z.string().uuid("That does not look like a valid identifier.").nullable(),
);

const optionalYear = z.preprocess(
  (value) => (value === "" || value === undefined || value === null ? null : Number(value)),
  z
    .number()
    .int()
    .min(1950, "Enter a year from 1950 onwards.")
    .max(2100, "That year looks wrong.")
    .nullable(),
);

export const usernameSchema = z
  .string()
  .trim()
  .min(3, "Usernames are at least 3 characters.")
  .max(24, "Usernames are at most 24 characters.")
  .regex(/^[a-zA-Z0-9_]+$/, "Use letters, numbers and underscores only.")
  .transform((value) => value.toLowerCase());

export const emailSchema = z.string().trim().toLowerCase().email("Enter a valid email address.").max(254);

export const displayNameSchema = z
  .string()
  .trim()
  .min(2, "Please use at least 2 characters.")
  .max(60, "Please keep this under 60 characters.");

export const passwordSchema = z
  .string()
  .min(8, "Use at least 8 characters.")
  .max(72, "Passwords are limited to 72 characters.")
  .regex(/[a-zA-Z]/, "Include at least one letter.")
  .regex(/[0-9]/, "Include at least one number.");

export const profileVisibilitySchema = z.enum(["public", "university", "private"]);

export const postCategorySchema = z.enum([
  "general",
  "campus_life",
  "academics",
  "exams",
  "relationships",
  "memes",
  "career",
  "complaints",
  "advice",
]);

/** Free-text fields that reference an uploaded object key, never a full URL we trust. */
const storagePath = optionalText(300);

export const interestsSchema = z.array(z.string().trim().min(1).max(40)).max(12);

/* ---------------------------------------------------------------------- auth */

export const signInSchema = z.object({
  email: emailSchema,
  password: z.string().min(1, "Enter your password."),
});

export const signUpSchema = z.object({
  displayName: displayNameSchema,
  email: emailSchema,
  password: passwordSchema,
  acceptGuidelines: z.literal(true, { message: "Please read and accept the community guidelines." }),
});

export const forgotPasswordSchema = z.object({ email: emailSchema });

export const resetPasswordSchema = z
  .object({
    token: z.string().min(10, "This reset link is incomplete."),
    password: passwordSchema,
    confirmPassword: z.string(),
  })
  .refine((value) => value.password === value.confirmPassword, {
    message: "Both passwords must match.",
    path: ["confirmPassword"],
  });

/* ----------------------------------------------------------------- onboarding */

export const onboardingBasicsSchema = z.object({
  displayName: displayNameSchema,
  username: usernameSchema,
  bio: optionalText(300),
  avatarPath: storagePath.optional(),
});

export const onboardingUniversitySchema = z.object({
  universityId: uuid,
  campusId: optionalUuid,
  country: z.string().trim().min(2).max(60).default("Pakistan"),
  degreeProgram: optionalText(120),
  department: optionalText(120),
  semester: optionalText(40),
  graduationYear: optionalYear,
});

export const notificationPrefsSchema = z.object({
  mentions: z.boolean(),
  comments: z.boolean(),
  replies: z.boolean(),
  likes: z.boolean(),
  channelActivity: z.boolean(),
  productUpdates: z.boolean(),
});

export const onboardingPreferencesSchema = z.object({
  bio: optionalText(300),
  profileVisibility: profileVisibilitySchema,
  interests: interestsSchema,
  notifications: notificationPrefsSchema,
});

/* -------------------------------------------------------------------- profile */

export const profileUpdateSchema = z.object({
  displayName: displayNameSchema,
  username: usernameSchema,
  bio: optionalText(300),
  universityId: optionalUuid,
  campusId: optionalUuid,
  degreeProgram: optionalText(120),
  department: optionalText(120),
  semester: optionalText(40),
  graduationYear: optionalYear,
  country: z.string().trim().min(2).max(60).default("Pakistan"),
  avatarUrl: storagePath,
  bannerUrl: storagePath,
});

export const privacyUpdateSchema = z.object({
  profileVisibility: profileVisibilitySchema,
  interests: interestsSchema,
});

/* ---------------------------------------------------------------------- posts */

export const createPostSchema = z.object({
  channelId: uuid,
  body: z
    .string()
    .trim()
    .min(2, "Write at least a couple of characters.")
    .max(POST_MAX_LENGTH, `Confessions are limited to ${POST_MAX_LENGTH} characters.`),
  isAnonymous: z.boolean(),
  category: postCategorySchema.nullable().catch(null),
  mediaPath: storagePath,
  poll: z
    .object({
      question: z.string().trim().min(4, "Give the poll a question.").max(POLL_QUESTION_MAX),
      options: z
        .array(z.string().trim().min(1, "Options cannot be empty.").max(POLL_OPTION_MAX))
        .min(MIN_POLL_OPTIONS, `A poll needs at least ${MIN_POLL_OPTIONS} options.`)
        .max(MAX_POLL_OPTIONS, `A poll can have at most ${MAX_POLL_OPTIONS} options.`),
      // A poll is never required to be multi-select or anonymous-voted; the
      // defaults match the column defaults in the schema.
      allowMultiple: z.boolean().default(false),
      anonymousVotes: z.boolean().default(true),
      closesAt: z.string().datetime().nullable().catch(null),
    })
    .nullable()
    .catch(null),
});

export const updatePostSchema = z.object({
  postId: uuid,
  body: z.string().trim().min(2, "Write at least a couple of characters.").max(POST_MAX_LENGTH),
  category: postCategorySchema.nullable().catch(null),
});

export const draftSchema = z.object({
  draftId: optionalUuid,
  channelId: optionalUuid,
  body: z.string().max(POST_MAX_LENGTH).default(""),
  isAnonymous: z.boolean().default(true),
  category: postCategorySchema.nullable().catch(null),
});

/* ------------------------------------------------------------------- comments */

export const commentSchema = z.object({
  postId: uuid,
  parentId: optionalUuid,
  body: z
    .string()
    .trim()
    .min(1, "Write a comment first.")
    .max(COMMENT_MAX_LENGTH, `Comments are limited to ${COMMENT_MAX_LENGTH} characters.`),
  isAnonymous: z.boolean(),
});

export const updateCommentSchema = z.object({
  commentId: uuid,
  body: z.string().trim().min(1, "Write a comment first.").max(COMMENT_MAX_LENGTH),
});

/* -------------------------------------------------------------------- reports */

export const reportSchema = z.object({
  targetType: z.enum(["post", "comment", "user"]),
  targetId: uuid,
  reason: z.enum([
    "harassment",
    "bullying",
    "threats",
    "hate_speech",
    "impersonation",
    "spam",
    "private_information",
    "inappropriate_content",
    "other",
  ]),
  description: optionalText(REPORT_DESCRIPTION_MAX),
});

/* ------------------------------------------------------- admin: the catalogue */

export const universityUpsertSchema = z.object({
  id: optionalUuid,
  name: z.string().trim().min(3, "Enter the institution name.").max(200),
  abbreviation: optionalText(40),
  description: optionalText(1200),
  city: optionalText(80),
  province: optionalText(80),
  institutionType: z.enum(["public", "private", "semi_government", "military", "unknown"]).default("unknown"),
  status: z.enum(["active", "pending_review", "merged", "archived"]).default("active"),
  isFeatured: z.boolean().default(false),
  isActive: z.boolean().default(true),
  logoUrl: storagePath,
  bannerUrl: storagePath,
});

export const campusUpsertSchema = z.object({
  id: optionalUuid,
  universityId: uuid,
  name: z.string().trim().min(2, "Enter the campus name.").max(160),
  city: optionalText(80),
  province: optionalText(80),
  isActive: z.boolean().default(true),
  isMain: z.boolean().default(false),
});

export const mergeUniversitiesSchema = z.object({
  sourceId: uuid,
  targetId: uuid,
});

/* ------------------------------------------------------- moderation & admin */

export const moderationDecisionSchema = z.object({
  reportId: uuid,
  decision: z.enum(["hide_content", "remove_content", "restore_content", "warn_user", "suspend_user", "dismiss"]),
  note: optionalText(1000),
});

export const deanonymiseSchema = z.object({
  postId: uuid,
  reason: z.string().trim().min(10, "Record why this disclosure is necessary.").max(500),
});

export const suspendUserSchema = z.object({
  userId: uuid,
  reason: z.string().trim().min(3, "Give a reason for the restriction.").max(300),
});

export const setRoleSchema = z.object({
  userId: uuid,
  role: z.enum(["user", "moderator", "admin"]),
});

export const setCommunityActiveSchema = z.object({
  channelId: uuid,
  isActive: z.boolean(),
});

/* ------------------------------------------------------------------- exports */

export const SEARCH_SCOPES = ["all", "universities", "campuses", "users", "posts"] as const;
export type SearchScope = (typeof SEARCH_SCOPES)[number];
