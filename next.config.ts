import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,

  // PGlite ships a WebAssembly build and resolves its own asset paths relative
  // to its package. Bundling it breaks those lookups, so it is loaded from
  // node_modules at runtime instead — the documented setup for server-side use.
  serverExternalPackages: ["@electric-sql/pglite"],

  experimental: {
    // Server Actions receive FormData straight from the browser; the default
    // 1 MB body limit is too small for an in-form image upload.
    serverActions: { bodySizeLimit: "6mb" },
  },

  images: {
    formats: ["image/avif", "image/webp"],
    remotePatterns: [
      // Supabase Storage public objects.
      { protocol: "https", hostname: "*.supabase.co", pathname: "/storage/v1/object/public/**" },
    ],
  },

  async headers() {
    return [
      {
        source: "/(.*)",
        headers: [
          { key: "X-Content-Type-Options", value: "nosniff" },
          { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
          { key: "X-Frame-Options", value: "SAMEORIGIN" },
          { key: "Permissions-Policy", value: "camera=(), microphone=(), geolocation=()" },
        ],
      },
      {
        source: "/(icon.svg|manifest.webmanifest)",
        headers: [
          { key: "Cache-Control", value: "public, max-age=86400, stale-while-revalidate=604800" },
        ],
      },
      {
        // Uploaded media is user content: never let a browser treat it as markup.
        source: "/media/:path*",
        headers: [{ key: "Content-Security-Policy", value: "default-src 'none'; sandbox" }],
      },
    ];
  },
};

export default nextConfig;
