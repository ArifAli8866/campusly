import Link from "next/link";

import { segmentBody } from "@/lib/mentions";

/**
 * Renders a post/comment body with mentions, hashtags and links.
 *
 * Mention resolution uses the *stored* mention rows passed in by the caller
 * (`resolved`), not a live username lookup, so a handle that no longer resolves
 * degrades to plain text rather than becoming a dead or misleading link.
 *
 * The body is never rendered as HTML: segments are emitted as React nodes, so
 * there is no path for injected markup.
 */
export function PostBody({
  body,
  resolved,
  className,
}: {
  body: string;
  resolved?: Record<string, string>;
  className?: string;
}) {
  const segments = segmentBody(body);

  return (
    <div className={className}>
      <p className="whitespace-pre-wrap break-words text-[0.9375rem] leading-[1.65] text-foreground">
        {segments.map((segment, index) => {
          switch (segment.type) {
            case "mention": {
              const username = resolved?.[segment.handle];
              if (!username) {
                return (
                  <span key={index} className="font-medium text-muted-foreground">
                    @{segment.handle}
                  </span>
                );
              }
              return (
                <Link
                  key={index}
                  href={`/u/${username}`}
                  className="font-medium text-accent hover:underline"
                >
                  @{username}
                </Link>
              );
            }
            case "hashtag":
              return (
                <Link
                  key={index}
                  href={`/search?q=${encodeURIComponent(`#${segment.value}`)}&scope=posts`}
                  className="font-medium text-accent hover:underline"
                >
                  #{segment.value}
                </Link>
              );
            case "link":
              return (
                <a
                  key={index}
                  href={segment.value}
                  target="_blank"
                  rel="noopener noreferrer nofollow ugc"
                  className="break-all font-medium text-accent hover:underline"
                >
                  {segment.value.replace(/^https?:\/\//, "").slice(0, 48)}
                  {segment.value.length > 60 ? "…" : ""}
                </a>
              );
            default:
              return <span key={index}>{segment.value}</span>;
          }
        })}
      </p>
    </div>
  );
}
