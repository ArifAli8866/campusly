import type { Metadata, Viewport } from "next";
import { Inter } from "next/font/google";
import { Toaster } from "sonner";

import { BRAND } from "@/components/brand";
import { ThemeProvider } from "@/components/theme-provider";
import { TooltipProvider } from "@/components/ui/overlays";
import { env } from "@/lib/env";

import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL(env.siteUrl),
  title: {
    default: `${BRAND.name} — ${BRAND.tagline}`,
    template: `%s · ${BRAND.name}`,
  },
  description:
    "Join your university community, share what is on your mind, and discover the stories students are talking about. Campusly hosts confession and discussion communities for campuses across Pakistan.",
  applicationName: BRAND.name,
  keywords: [
    "university confessions",
    "Pakistan universities",
    "student community",
    "campus life",
    "anonymous confessions",
    "FAST-NUCES",
    "NUST",
    "LUMS",
    "GIKI",
    "UET",
  ],
  authors: [{ name: BRAND.name }],
  creator: BRAND.name,
  openGraph: {
    type: "website",
    locale: "en_PK",
    siteName: BRAND.name,
    title: `${BRAND.name} — ${BRAND.tagline}`,
    description:
      "University confession and discussion communities for campuses across Pakistan. Join anonymously or under your profile.",
    url: env.siteUrl,
  },
  twitter: {
    card: "summary_large_image",
    title: `${BRAND.name} — ${BRAND.tagline}`,
    description: "University confession and discussion communities for campuses across Pakistan.",
  },
  robots: {
    index: true,
    follow: true,
    googleBot: { index: true, follow: true },
  },
  manifest: "/manifest.webmanifest",
  icons: {
    icon: [{ url: "/icon.svg", type: "image/svg+xml" }],
    apple: [{ url: "/icon.svg" }],
  },
  formatDetection: { telephone: false, address: false, email: false },
};

export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "#ffffff" },
    { media: "(prefers-color-scheme: dark)", color: "#0b0b0d" },
  ],
  width: "device-width",
  initialScale: 1,
  viewportFit: "cover",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning className={inter.variable}>
      <body className="min-h-dvh antialiased">
        <ThemeProvider>
          <TooltipProvider>
            <a
              href="#main"
              className="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-[100] focus:rounded-lg focus:bg-primary focus:px-4 focus:py-2 focus:text-sm focus:text-primary-foreground"
            >
              Skip to content
            </a>
            {children}
            <Toaster
              position="bottom-center"
              closeButton
              toastOptions={{
                classNames: {
                  toast:
                    "!rounded-xl !border !border-border !bg-card !text-foreground !shadow-[var(--shadow-pop)] !text-[0.8125rem]",
                  description: "!text-muted-foreground",
                },
              }}
            />
          </TooltipProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
