import { describe, expect, it } from "vitest";
import { getClientIp } from "../lib/ip";
import { sniffMime, validateUpload } from "../storage";

describe("getClientIp", () => {
  it("prioritizes cf-connecting-ip when present", () => {
    const headers = new Headers({
      "cf-connecting-ip": "203.0.113.195",
      "x-forwarded-for": "198.51.100.1, 192.0.2.1",
    });
    expect(getClientIp(headers)).toBe("203.0.113.195");
  });

  it("extracts the first IP from comma-separated x-forwarded-for header", () => {
    const headers = new Headers({
      "x-forwarded-for": "198.51.100.42, 10.0.0.1, 172.16.0.1",
    });
    expect(getClientIp(headers)).toBe("198.51.100.42");
  });

  it("falls back to x-real-ip when x-forwarded-for is missing", () => {
    const headers = new Headers({
      "x-real-ip": "192.0.2.99",
    });
    expect(getClientIp(headers)).toBe("192.0.2.99");
  });

  it("returns 127.0.0.1 when no proxy headers are present", () => {
    const headers = new Headers();
    expect(getClientIp(headers)).toBe("127.0.0.1");
  });
});

describe("sniffMime & validateUpload", () => {
  it("detects PNG magic bytes", () => {
    const pngHeader = new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d]);
    expect(sniffMime(pngHeader)).toBe("image/png");
  });

  it("detects JPEG magic bytes", () => {
    const jpegHeader = new Uint8Array([0xff, 0xd8, 0xff, 0xe0, 0x00, 0x10, 0x4a, 0x46, 0x49, 0x46, 0x00, 0x01]);
    expect(sniffMime(jpegHeader)).toBe("image/jpeg");
  });

  it("rejects non-image binaries or spoofed files", () => {
    const scriptHeader = new Uint8Array([0x3c, 0x3f, 0x70, 0x68, 0x70, 0x20, 0x65, 0x63, 0x68, 0x6f, 0x20, 0x31]);
    expect(sniffMime(scriptHeader)).toBeNull();
  });

  it("validates upload size bounds", () => {
    const emptyFile = { size: 0, arrayBuffer: async () => new ArrayBuffer(0) };
    expect(validateUpload("avatars", emptyFile)).toEqual({
      ok: false,
      error: "That file is empty.",
    });

    const oversized = { size: 10 * 1024 * 1024, arrayBuffer: async () => new ArrayBuffer(0) };
    expect(validateUpload("avatars", oversized)).toEqual({
      ok: false,
      error: "Images must be smaller than 2 MB.",
    });
  });
});
