import type { MetadataRoute } from "next";

import { env } from "@/lib/env";
import { dbAs } from "@/lib/db";
import { getUniversityCards } from "@/server/services/queries";

export const revalidate = 3600;

/** Static pages plus every real university page, read from the database. */
export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const base = env.siteUrl.replace(/\/$/, "");

  const staticRoutes: MetadataRoute.Sitemap = [
    { url: `${base}/`, changeFrequency: "daily", priority: 1 },
    { url: `${base}/universities`, changeFrequency: "daily", priority: 0.9 },
    { url: `${base}/discover`, changeFrequency: "weekly", priority: 0.6 },
    { url: `${base}/search`, changeFrequency: "weekly", priority: 0.5 },
    { url: `${base}/community-guidelines`, changeFrequency: "monthly", priority: 0.4 },
    { url: `${base}/about`, changeFrequency: "monthly", priority: 0.4 },
    { url: `${base}/privacy`, changeFrequency: "monthly", priority: 0.3 },
    { url: `${base}/terms`, changeFrequency: "monthly", priority: 0.3 },
  ];

  try {
    const scope = { db: await dbAs(null), userId: null };
    const universities = await getUniversityCards(scope, { limit: 500 });

    return [
      ...staticRoutes,
      ...universities.map((university) => ({
        url: `${base}/universities/${university.slug}`,
        changeFrequency: "weekly" as const,
        priority: 0.7,
      })),
    ];
  } catch {
    // A sitemap must never take the site down; fall back to the static routes.
    return staticRoutes;
  }
}
