"use client";

import { useOptimistic, useTransition } from "react";
import { Check } from "lucide-react";
import { toast } from "sonner";

import type { PollView } from "@/lib/db/types";
import { cn, compactNumber } from "@/lib/utils";
import { votePollAction } from "@/server/actions/social";

/**
 * Poll results are only shown after voting, so a reader cannot be nudged by the
 * current tally. Counts come from `poll_options.vote_count`, maintained by a
 * trigger on `poll_votes` — never computed from client state.
 */
export function PollCard({ poll }: { postId?: string; poll: PollView }) {
  const [isPending, startTransition] = useTransition();
  const [votes, addVote] = useOptimistic(
    poll.options,
    (state, optionId: string) => state.map((o) => (o.id === optionId ? { ...o, voted: true, votes: o.votes + 1 } : o)),
  );

  const hasVoted = votes.some((option) => option.voted);
  const total = votes.reduce((sum, option) => sum + option.votes, 0);
  const closed = poll.closes_at ? new Date(poll.closes_at).getTime() < Date.now() : false;

  function vote(optionId: string) {
    if (hasVoted && !poll.allow_multiple) {
      toast.error("You have already voted in this poll.");
      return;
    }

    startTransition(async () => {
      addVote(optionId);
      const result = await votePollAction(poll.id, optionId);
      if (!result.ok) toast.error(result.error);
    });
  }

  return (
    <div className="mt-3 rounded-xl border border-border bg-muted/30 p-3.5">
      <p className="text-[0.8125rem] font-semibold">{poll.question}</p>

      <ul className="mt-3 space-y-2">
        {votes.map((option) => {
          const share = total > 0 ? Math.round((option.votes / total) * 100) : 0;
          const showResults = hasVoted || closed;

          return (
            <li key={option.id}>
              <button
                type="button"
                onClick={() => vote(option.id)}
                disabled={isPending || closed || (hasVoted && !poll.allow_multiple)}
                aria-pressed={option.voted}
                aria-label={
                  showResults ? `${option.label}: ${share}%` : `Vote for ${option.label}`
                }
                className={cn(
                  "relative w-full overflow-hidden rounded-lg border px-3 py-2 text-left text-[0.8125rem] transition-colors",
                  "disabled:cursor-default",
                  option.voted
                    ? "border-accent/40 bg-accent-subtle"
                    : "border-border bg-card hover:border-border-strong",
                )}
              >
                {showResults ? (
                  <span
                    aria-hidden
                    className={cn(
                      "absolute inset-y-0 left-0 -z-0 transition-[width] duration-500",
                      option.voted ? "bg-accent/12" : "bg-muted",
                    )}
                    style={{ width: `${share}%` }}
                  />
                ) : null}

                <span className="relative flex items-center justify-between gap-3">
                  <span className="flex items-center gap-2">
                    {option.voted ? <Check className="size-3.5 text-accent" aria-hidden /> : null}
                    <span className={cn(option.voted && "font-medium")}>{option.label}</span>
                  </span>
                  {showResults ? (
                    <span className="tabular-nums text-xs text-muted-foreground">{share}%</span>
                  ) : null}
                </span>
              </button>
            </li>
          );
        })}
      </ul>

      <p className="mt-2.5 text-xs text-muted-foreground">
        {closed
          ? `Closed · ${compactNumber(total)} ${total === 1 ? "vote" : "votes"}`
          : hasVoted
            ? `${compactNumber(total)} ${total === 1 ? "vote" : "votes"}${poll.allow_multiple ? " · multiple answers allowed" : ""}`
            : "Vote to see results"}
      </p>
    </div>
  );
}
