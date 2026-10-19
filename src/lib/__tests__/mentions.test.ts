import { describe, expect, it } from "vitest";
import { extractMentionHandles, segmentBody } from "../mentions";

describe("extractMentionHandles", () => {
  it("extracts unique valid mention handles from text", () => {
    const text = "Hello @ayesha and @talha, did @ayesha submit the assignment?";
    expect(extractMentionHandles(text)).toEqual(["ayesha", "talha"]);
  });

  it("ignores invalid or short handles", () => {
    const text = "Email test@example.com or ping @ab or @@invalid";
    expect(extractMentionHandles(text)).toEqual([]);
  });

  it("handles empty body", () => {
    expect(extractMentionHandles("")).toEqual([]);
  });
});

describe("segmentBody", () => {
  it("segments text into text, mentions, hashtags, and links", () => {
    const input = "Hey @ayesha checkout #exam at https://campusly.pk";
    const segments = segmentBody(input);

    expect(segments).toEqual([
      { type: "text", value: "Hey" },
      { type: "text", value: " " },
      { type: "mention", handle: "ayesha" },
      { type: "text", value: " checkout " },
      { type: "hashtag", value: "exam" },
      { type: "text", value: " at " },
      { type: "link", value: "https://campusly.pk" },
    ]);
  });

  it("handles plain text without entities", () => {
    const input = "Plain confession with no special syntax.";
    const segments = segmentBody(input);
    expect(segments).toEqual([{ type: "text", value: input }]);
  });
});
