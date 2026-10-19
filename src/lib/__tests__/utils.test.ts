import { describe, expect, it } from "vitest";
import {
  cn,
  compactNumber,
  formatDate,
  hueFrom,
  initials,
  isSafeUrl,
  joinedLabel,
  normaliseUsername,
  pluralize,
  relativeTime,
  truncate,
} from "../utils";

describe("cn", () => {
  it("merges class names correctly without duplicates", () => {
    expect(cn("px-2 py-1", "bg-red-500", { "text-white": true, "opacity-50": false })).toBe(
      "px-2 py-1 bg-red-500 text-white",
    );
    expect(cn("p-4", "p-2")).toBe("p-2");
  });
});

describe("initials", () => {
  it("extracts up to two capital initials", () => {
    expect(initials("Arif Ali")).toBe("AA");
    expect(initials("john")).toBe("J");
    expect(initials("Muhammad Talha Khan")).toBe("MT");
    expect(initials("")).toBe("");
  });
});

describe("hueFrom", () => {
  it("deterministically generates hue within [0, 360)", () => {
    const hue1 = hueFrom("user-123");
    const hue2 = hueFrom("user-123");
    expect(hue1).toBe(hue2);
    expect(hue1).toBeGreaterThanOrEqual(0);
    expect(hue1).toBeLessThan(360);
  });
});

describe("compactNumber", () => {
  it("formats counts into human readable abbreviations", () => {
    expect(compactNumber(0)).toBe("0");
    expect(compactNumber(500)).toBe("500");
    expect(compactNumber(1000)).toBe("1K");
    expect(compactNumber(1500)).toBe("1.5K");
    expect(compactNumber(12500)).toBe("13K");
    expect(compactNumber(1000000)).toBe("1M");
    expect(compactNumber(2500000)).toBe("2.5M");
  });
});

describe("pluralize", () => {
  it("pluralizes based on count", () => {
    expect(pluralize(1, "confession")).toBe("confession");
    expect(pluralize(0, "confession")).toBe("confessions");
    expect(pluralize(5, "confession")).toBe("confessions");
    expect(pluralize(2, "person", "people")).toBe("people");
  });
});

describe("truncate", () => {
  it("truncates string to max characters with ellipsis", () => {
    expect(truncate("hello world", 20)).toBe("hello world");
    expect(truncate("hello world long text", 10)).toBe("hello worl…");
  });
});

describe("normaliseUsername", () => {
  it("converts to lowercase and strips non-alphanumeric/underscore characters", () => {
    expect(normaliseUsername("Arif_Ali-123!")).toBe("arif_ali123");
    expect(normaliseUsername("User@Name")).toBe("username");
  });
});

describe("isSafeUrl", () => {
  it("validates safe HTTP/HTTPS URLs and rejects unsafe protocols", () => {
    expect(isSafeUrl("https://campusly.pk")).toBe(true);
    expect(isSafeUrl("http://localhost:3000")).toBe(true);
    expect(isSafeUrl("javascript:alert(1)")).toBe(false);
    expect(isSafeUrl("data:text/html,hack")).toBe(false);
    expect(isSafeUrl("not a url")).toBe(false);
  });
});

describe("relativeTime and date formatting", () => {
  it("formats relative timestamps correctly", () => {
    const now = new Date();
    expect(relativeTime(now)).toBe("just now");
    const tenMinAgo = new Date(Date.now() - 10 * 60 * 1000);
    expect(relativeTime(tenMinAgo)).toBe("10 min ago");
  });

  it("formats joined labels", () => {
    const date = new Date(2025, 0, 15);
    expect(joinedLabel(date)).toContain("2025");
    expect(formatDate(date)).toContain("2025");
  });
});
