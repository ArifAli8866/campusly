/**
 * Navigation is declared once, here, and consumed by the header dock, the
 * mobile sheet and the footer. Icons are referenced by *name* rather than by
 * component: a component is a function, and functions cannot cross the
 * server → client boundary — the client modules look the name up in ICONS.
 */
import { Bell, Bookmark, Compass, FileEdit, Home, Layers, PenLine, Search, ShieldCheck, Users } from "lucide-react";

export type NavIcon =
  | "home"
  | "compass"
  | "layers"
  | "search"
  | "bell"
  | "bookmark"
  | "drafts"
  | "compose"
  | "users"
  | "shield";

export const ICONS = {
  home: Home,
  compass: Compass,
  layers: Layers,
  search: Search,
  bell: Bell,
  bookmark: Bookmark,
  drafts: FileEdit,
  compose: PenLine,
  users: Users,
  shield: ShieldCheck,
} as const satisfies Record<NavIcon, unknown>;

export interface NavItem {
  href: string;
  label: string;
  icon: NavIcon;
  /** Match nested routes (`/universities/foo`) as well as the exact path. */
  matchNested?: boolean;
}

/** The public marketing navigation, rendered inside the floating dock. */
export const PUBLIC_NAV: NavItem[] = [
  { href: "/universities", label: "Universities", icon: "compass", matchNested: true },
  { href: "/discover", label: "Students", icon: "users" },
  { href: "/#how-it-works", label: "How it works", icon: "layers" },
];

/** Signed-in primary navigation. */
export const APP_NAV: NavItem[] = [
  { href: "/home", label: "Home", icon: "home" },
  { href: "/explore", label: "Explore", icon: "compass" },
  { href: "/joined", label: "My communities", icon: "layers" },
  { href: "/search", label: "Search", icon: "search" },
];

/** Signed-in secondary navigation. */
export const ACCOUNT_NAV: NavItem[] = [
  { href: "/notifications", label: "Notifications", icon: "bell" },
  { href: "/saved", label: "Saved", icon: "bookmark" },
  { href: "/drafts", label: "Drafts", icon: "drafts" },
];

export const MODERATION_NAV: NavItem[] = [
  { href: "/moderation", label: "Moderation queue", icon: "shield", matchNested: true },
];

export const FOOTER_NAV: { title: string; links: { href: string; label: string }[] }[] = [
  {
    title: "Product",
    links: [
      { href: "/universities", label: "Universities" },
      { href: "/discover", label: "Discover students" },
      { href: "/#how-it-works", label: "How it works" },
      { href: "/search", label: "Search" },
    ],
  },
  {
    title: "Community",
    links: [
      { href: "/community-guidelines", label: "Community guidelines" },
      { href: "/report-abuse", label: "Report a problem" },
      { href: "/about", label: "About" },
    ],
  },
  {
    title: "Legal",
    links: [
      { href: "/privacy", label: "Privacy policy" },
      { href: "/terms", label: "Terms of service" },
    ],
  },
];
