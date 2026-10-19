import { describe, expect, it } from "vitest";
import {
  createPostSchema,
  displayNameSchema,
  emailSchema,
  passwordSchema,
  postCategorySchema,
  profileVisibilitySchema,
  reportSchema,
  signInSchema,
  signUpSchema,
  usernameSchema,
} from "../validation/schemas";

describe("usernameSchema", () => {
  it("accepts valid usernames and transforms to lowercase", () => {
    expect(usernameSchema.parse("Arif_Ali88")).toBe("arif_ali88");
    expect(usernameSchema.parse("talha_99")).toBe("talha_99");
  });

  it("rejects usernames that are too short or too long", () => {
    expect(() => usernameSchema.parse("ab")).toThrow();
    expect(() => usernameSchema.parse("a".repeat(25))).toThrow();
  });

  it("rejects special characters and spaces", () => {
    expect(() => usernameSchema.parse("arif ali")).toThrow();
    expect(() => usernameSchema.parse("arif@ali")).toThrow();
    expect(() => usernameSchema.parse("arif-ali")).toThrow();
  });
});

describe("emailSchema", () => {
  it("normalizes and accepts valid email", () => {
    expect(emailSchema.parse("  STUDENT@NUST.EDU.PK  ")).toBe("student@nust.edu.pk");
  });

  it("rejects malformed emails", () => {
    expect(() => emailSchema.parse("not-an-email")).toThrow();
    expect(() => emailSchema.parse("@no-user.com")).toThrow();
  });
});

describe("displayNameSchema", () => {
  it("accepts valid names", () => {
    expect(displayNameSchema.parse("Arif Ali")).toBe("Arif Ali");
  });

  it("rejects empty or 1-character names", () => {
    expect(() => displayNameSchema.parse("A")).toThrow();
    expect(() => displayNameSchema.parse("")).toThrow();
  });
});

describe("passwordSchema", () => {
  it("accepts strong password containing letters and numbers", () => {
    expect(passwordSchema.parse("secret1234")).toBe("secret1234");
  });

  it("rejects passwords lacking numbers or letters or too short", () => {
    expect(() => passwordSchema.parse("short1")).toThrow();
    expect(() => passwordSchema.parse("onlyletters")).toThrow();
    expect(() => passwordSchema.parse("123456789")).toThrow();
  });
});

describe("signUpSchema", () => {
  it("accepts valid signup input", () => {
    const valid = {
      displayName: "Fatima Noor",
      email: "fatima@fast.edu.pk",
      password: "Password123",
      acceptGuidelines: true,
    };
    expect(signUpSchema.parse(valid)).toMatchObject({
      displayName: "Fatima Noor",
      email: "fatima@fast.edu.pk",
    });
  });

  it("rejects unaccepted guidelines", () => {
    const invalid = {
      displayName: "Fatima Noor",
      email: "fatima@fast.edu.pk",
      password: "Password123",
      acceptGuidelines: false,
    };
    expect(() => signUpSchema.parse(invalid)).toThrow();
  });
});

describe("createPostSchema", () => {
  const channelId = "123e4567-e89b-12d3-a456-426614174000";

  it("accepts valid anonymous confession", () => {
    const res = createPostSchema.parse({
      channelId,
      body: "Honest opinion: the campus library needs more silent study rooms.",
      isAnonymous: true,
      category: "campus_life",
    });
    expect(res.channelId).toBe(channelId);
    expect(res.isAnonymous).toBe(true);
    expect(res.category).toBe("campus_life");
  });

  it("rejects invalid channel uuid", () => {
    expect(() =>
      createPostSchema.parse({
        channelId: "not-a-uuid",
        body: "Valid body text",
        isAnonymous: false,
      }),
    ).toThrow();
  });
});

describe("profileVisibilitySchema & postCategorySchema", () => {
  it("validates enum choices", () => {
    expect(profileVisibilitySchema.parse("university")).toBe("university");
    expect(() => profileVisibilitySchema.parse("unknown")).toThrow();

    expect(postCategorySchema.parse("academics")).toBe("academics");
    expect(() => postCategorySchema.parse("invalid_cat")).toThrow();
  });
});

describe("signInSchema", () => {
  it("validates login credentials", () => {
    const creds = signInSchema.parse({
      email: "student@fast.edu.pk",
      password: "password123",
    });
    expect(creds.email).toBe("student@fast.edu.pk");
  });
});

describe("reportSchema", () => {
  it("validates report submission", () => {
    const res = reportSchema.parse({
      targetType: "post",
      targetId: "123e4567-e89b-12d3-a456-426614174000",
      reason: "harassment",
      description: "Inappropriate personal attacks.",
    });
    expect(res.reason).toBe("harassment");
    expect(res.targetType).toBe("post");
  });
});
