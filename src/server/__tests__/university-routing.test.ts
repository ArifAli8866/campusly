import { describe, expect, it } from "vitest";

describe("University and Channel Slug Routing", () => {
  it("normalizes university names into valid url slugs", () => {
    const normalizeSlug = (name: string) =>
      name
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, "-")
        .replace(/(^-|-$)/g, "");

    expect(normalizeSlug("Bahauddin Zakariya University")).toBe("bahauddin-zakariya-university");
    expect(normalizeSlug("FAST - National University of Computer & Emerging Sciences")).toBe(
      "fast-national-university-of-computer-emerging-sciences",
    );
    expect(normalizeSlug("National University of Sciences and Technology (NUST)")).toBe(
      "national-university-of-sciences-and-technology-nust",
    );
  });

  it("handles acronym-to-campus mapping correctly", () => {
    const parseAcronymRoute = (slug: string) => {
      const parts = slug.toLowerCase().split("-");
      return {
        prefix: parts[0],
        hasCampus: parts.length > 1,
      };
    };

    expect(parseAcronymRoute("nust")).toEqual({ prefix: "nust", hasCampus: false });
    expect(parseAcronymRoute("fast-islamabad")).toEqual({ prefix: "fast", hasCampus: true });
    expect(parseAcronymRoute("lums-lahore")).toEqual({ prefix: "lums", hasCampus: true });
  });

  it("resolves canonical channel redirection path correctly", () => {
    const resolveCanonicalRedirect = (requestedSlug: string, canonicalSlug: string) => {
      if (requestedSlug.toLowerCase() !== canonicalSlug.toLowerCase()) {
        return `/channels/${canonicalSlug}`;
      }
      return null;
    };

    expect(resolveCanonicalRedirect("nust", "national-university-of-sciences-and-technology-islamabad-campus")).toBe(
      "/channels/national-university-of-sciences-and-technology-islamabad-campus",
    );
    expect(
      resolveCanonicalRedirect(
        "abbottabad-university-of-science-and-technology-main-campus",
        "abbottabad-university-of-science-and-technology",
      ),
    ).toBe("/channels/abbottabad-university-of-science-and-technology");
    expect(
      resolveCanonicalRedirect(
        "abbottabad-university-of-science-and-technology",
        "abbottabad-university-of-science-and-technology",
      ),
    ).toBeNull();
  });
});
