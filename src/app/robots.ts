import type { MetadataRoute } from "next";

import { env } from "@/lib/env";

/**
 * Private surfaces are excluded: a notification, a draft, a settings page or a
 * moderation queue has no business being indexed, and an anonymous post must
 * never be reachable through a search engine's cache.
 */
export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: "*",
        allow: "/",
        disallow: [
          "/api/",
          "/auth/",
          "/home",
          "/notifications",
          "/saved",
          "/drafts",
          "/settings",
          "/moderation",
          "/admin",
          "/compose",
          "/onboarding",
          "/login",
          "/signup",
          "/forgot-password",
          "/reset-password",
        ],
      },
    ],
    sitemap: `${env.siteUrl}/sitemap.xml`,
    host: env.siteUrl,
  };
}
