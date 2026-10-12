"use client";

import { useCallback, useEffect, useMemo, useRef, useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import {
  BarChart3,
  Eye,
  EyeOff,
  Hash,
  ImagePlus,
  Info,
  Loader2,
  Plus,
  Save,
  Send,
  Trash2,
  Users,
  X,
} from "lucide-react";
import { toast } from "sonner";

import { Avatar, Badge } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { Field, InlineAlert, NativeSelect, Textarea, Input } from "@/components/ui/fields";
import {
  Dialog,
  DialogContent,
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuTrigger,
} from "@/components/ui/overlays";
import { POST_CATEGORIES, POST_MAX_LENGTH } from "@/lib/constants";
import { cn, compactNumber } from "@/lib/utils";
import { createPostAction, saveDraftAction } from "@/server/actions/posts";
import { searchUsersForMentionAction } from "@/server/actions/profile";

export interface ComposerChannel {
  id: string;
  slug: string;
  name: string;
  label: string;
}

export interface ComposerProps {
  channels: ComposerChannel[];
  defaultChannelId?: string;
  defaultAnonymous?: boolean;
  currentUser: { displayName: string; username: string; avatarUrl: string | null };
  /** Rendered as a fixed button on mobile instead of an inline panel. */
  variant?: "inline" | "dialog";
  draftId?: string | null;
  initialBody?: string;
  trigger?: React.ReactNode;
  onPublished?: (postId: string) => void;
}

interface MentionCandidate {
  id: string;
  username: string;
  displayName: string;
  avatarUrl: string | null;
}

export function Composer({
  channels,
  defaultChannelId,
  defaultAnonymous = true,
  currentUser,
  variant = "inline",
  draftId = null,
  initialBody = "",
  trigger,
  onPublished,
}: ComposerProps) {
  const router = useRouter();
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  const [open, setOpen] = useState(variant === "inline");
  const [body, setBody] = useState(initialBody);
  const [channelId, setChannelId] = useState(defaultChannelId ?? channels[0]?.id ?? "");
  const [isAnonymous, setIsAnonymous] = useState(defaultAnonymous);
  const [category, setCategory] = useState<string>("");
  const [mediaPath, setMediaPath] = useState<string | null>(null);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [preview, setPreview] = useState(false);
  const [showPoll, setShowPoll] = useState(false);
  const [poll, setPoll] = useState<{ question: string; options: string[] }>({ question: "", options: ["", ""] });
  const [isPending, startTransition] = useTransition();

  // ---- mention autocomplete ------------------------------------------------
  const [mentionQuery, setMentionQuery] = useState<string | null>(null);
  const [mentionResults, setMentionResults] = useState<MentionCandidate[]>([]);
  const [mentionIndex, setMentionIndex] = useState(0);
  const [mentionLoading, setMentionLoading] = useState(false);

  const remaining = POST_MAX_LENGTH - body.length;
  const canSubmit = body.trim().length > 0 && channelId !== "" && remaining >= 0;

  const selectedChannel = useMemo(() => channels.find((c) => c.id === channelId), [channels, channelId]);

  /* ------------------------------------------------------- mention handling */

  useEffect(() => {
    if (mentionQuery === null) return;

    let cancelled = false;
    setMentionLoading(true);
    const timer = setTimeout(async () => {
      const result = await searchUsersForMentionAction(mentionQuery);
      if (cancelled) return;
      setMentionResults(result.ok ? (result.data ?? []) : []);
      setMentionIndex(0);
      setMentionLoading(false);
    }, 180);

    return () => {
      cancelled = true;
      clearTimeout(timer);
    };
  }, [mentionQuery]);

  /** Detect an in-progress @handle immediately before the caret. */
  const syncMentionQuery = useCallback((value: string, caret: number) => {
    const upToCaret = value.slice(0, caret);
    const match = /(?:^|\s)@([a-zA-Z0-9_]{0,24})$/.exec(upToCaret);
    setMentionQuery(match ? match[1]!.toLowerCase() : null);
  }, []);

  function insertMention(candidate: MentionCandidate) {
    const textarea = textareaRef.current;
    if (!textarea) return;

    const caret = textarea.selectionStart;
    const before = body.slice(0, caret);
    const after = body.slice(caret);

    const replaced = before.replace(/(^|\s)@([a-zA-Z0-9_]{0,24})$/, `$1@${candidate.username} `);
    const next = replaced + after;

    setBody(next.slice(0, POST_MAX_LENGTH));
    setMentionQuery(null);
    setMentionResults([]);

    requestAnimationFrame(() => {
      const position = replaced.length;
      textarea.focus();
      textarea.setSelectionRange(position, position);
    });
  }

  function handleKeyDown(event: React.KeyboardEvent<HTMLTextAreaElement>) {
    if (mentionQuery !== null && mentionResults.length > 0) {
      if (event.key === "ArrowDown") {
        event.preventDefault();
        setMentionIndex((index) => (index + 1) % mentionResults.length);
        return;
      }
      if (event.key === "ArrowUp") {
        event.preventDefault();
        setMentionIndex((index) => (index - 1 + mentionResults.length) % mentionResults.length);
        return;
      }
      if (event.key === "Enter" || event.key === "Tab") {
        event.preventDefault();
        insertMention(mentionResults[mentionIndex]!);
        return;
      }
      if (event.key === "Escape") {
        setMentionQuery(null);
        return;
      }
    }

    // Cmd/Ctrl+Enter publishes — the expected shortcut for a long-form box.
    if ((event.metaKey || event.ctrlKey) && event.key === "Enter" && canSubmit && !isPending) {
      event.preventDefault();
      event.currentTarget.form?.requestSubmit();
    }
  }

  /* --------------------------------------------------------------- uploading */

  async function handleFile(event: React.ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0];
    event.target.value = "";
    if (!file) return;

    setUploading(true);
    setError(null);

    const payload = new FormData();
    payload.set("bucket", "post-media");
    payload.set("file", file);

    try {
      const response = await fetch("/api/upload", { method: "POST", body: payload });
      const data = (await response.json()) as { path?: string; error?: string };
      if (!response.ok || !data.path) {
        setError(data.error ?? "The image could not be uploaded.");
        return;
      }
      setMediaPath(data.path);
    } catch {
      setError("The image could not be uploaded. Check your connection.");
    } finally {
      setUploading(false);
    }
  }

  /* ---------------------------------------------------------------- publish */

  function handleSubmit(formData: FormData) {
    setError(null);

    const pollPayload =
      showPoll && poll.question.trim().length >= 2 && poll.options.filter((o) => o.trim()).length >= 2
        ? JSON.stringify({
            question: poll.question.trim(),
            options: poll.options.map((o) => o.trim()).filter(Boolean),
            allowMultiple: false,
            anonymousVotes: true,
          })
        : null;

    formData.set("poll", pollPayload ?? "");

    startTransition(async () => {
      const result = await createPostAction(formData);

      if (!result.ok) {
        setError(result.error);
        // Keep the draft so nothing the student wrote is lost on a failure.
        const keep = new FormData();
        keep.set("draftId", draftId ?? "");
        keep.set("channelId", channelId);
        keep.set("body", body);
        keep.set("isAnonymous", String(isAnonymous));
        keep.set("category", category);
        await saveDraftAction(keep).catch(() => undefined);
        toast.error("We saved your text as a draft.");
        return;
      }

      toast.success(isAnonymous ? "Posted anonymously." : "Posted.");
      setBody("");
      setMediaPath(null);
      setPoll({ question: "", options: ["", ""] });
      setShowPoll(false);
      onPublished?.(result.data!.postId);
      if (variant === "dialog") setOpen(false);
      router.refresh();
    });
  }

  function handleSaveDraft() {
    const formData = new FormData();
    formData.set("draftId", draftId ?? "");
    formData.set("channelId", channelId);
    formData.set("body", body);
    formData.set("isAnonymous", String(isAnonymous));
    formData.set("category", category);

    startTransition(async () => {
      const result = await saveDraftAction(formData);
      if (!result.ok) {
        toast.error(result.error);
        return;
      }
      toast.success("Draft saved privately. Only you can see it.");
    });
  }

  /* ----------------------------------------------------------------- render */

  const panel = (
    <form action={handleSubmit} className="space-y-3">
      <input type="hidden" name="channelId" value={channelId} />
      <input type="hidden" name="isAnonymous" value={String(isAnonymous)} />
      <input type="hidden" name="category" value={category} />
      <input type="hidden" name="mediaPath" value={mediaPath ?? ""} />

      {/* identity switch */}
      <div
        className={cn(
          "flex items-center gap-3 rounded-xl border px-3 py-2.5 transition-colors",
          isAnonymous ? "border-accent/30 bg-accent-subtle" : "border-border bg-muted/40",
        )}
      >
        <Avatar
          src={isAnonymous ? null : currentUser.avatarUrl}
          name={isAnonymous ? "Anonymous" : currentUser.displayName}
          anonymous={isAnonymous}
          size="sm"
        />
        <div className="min-w-0 flex-1">
          <p className="text-[0.8125rem] font-medium">
            {isAnonymous ? "Posting anonymously" : `Posting as @${currentUser.username}`}
          </p>
          <p className="text-xs text-muted-foreground">
            {isAnonymous
              ? "Your name, username and photo stay hidden from students. Moderators can only reveal you through a logged review."
              : "Your profile will be linked on this post."}
          </p>
        </div>

        <Button
          type="button"
          variant={isAnonymous ? "outline" : "primary"}
          size="sm"
          onClick={() => setIsAnonymous((value) => !value)}
          aria-pressed={!isAnonymous}
        >
          {isAnonymous ? <Eye className="size-3.5" /> : <EyeOff className="size-3.5" />}
          {isAnonymous ? "Go public" : "Go anonymous"}
        </Button>
      </div>

      {/* channel + category */}
      <div className="grid gap-2 sm:grid-cols-2">
        <Field label="Community" htmlFor="composer-channel">
          <NativeSelect
            id="composer-channel"
            value={channelId}
            onChange={(event) => setChannelId(event.target.value)}
            required
          >
            {channels.length === 0 ? <option value="">Join a community first</option> : null}
            {channels.map((channel) => (
              <option key={channel.id} value={channel.id}>
                {channel.label}
              </option>
            ))}
          </NativeSelect>
        </Field>

        <Field label="Category" htmlFor="composer-category" optional>
          <NativeSelect
            id="composer-category"
            value={category}
            onChange={(event) => setCategory(event.target.value)}
          >
            <option value="">No category</option>
            {POST_CATEGORIES.map((item) => (
              <option key={item.value} value={item.value}>
                {item.label}
              </option>
            ))}
          </NativeSelect>
        </Field>
      </div>

      {/* body */}
      <div className="relative">
        <Textarea
          ref={textareaRef}
          id="composer-body"
          name="body"
          value={body}
          onChange={(event) => {
            setBody(event.target.value.slice(0, POST_MAX_LENGTH));
            syncMentionQuery(event.target.value, event.target.selectionStart ?? 0);
          }}
          onKeyDown={handleKeyDown}
          placeholder={
            isAnonymous
              ? "What is on your mind? Nobody will know it was you."
              : `Share something as @${currentUser.username}…`
          }
          maxLength={POST_MAX_LENGTH}
          rows={variant === "dialog" ? 6 : 4}
          aria-describedby="composer-counter"
          className="min-h-[7rem] resize-y pr-3"
        />

        {mentionQuery !== null ? (
          <div
            role="listbox"
            aria-label="Mention suggestions"
            className="absolute bottom-full left-0 z-30 mb-2 w-full max-w-sm overflow-hidden rounded-xl border border-border bg-card shadow-[var(--shadow-pop)]"
          >
            {mentionLoading && mentionResults.length === 0 ? (
              <p className="flex items-center gap-2 px-3 py-2.5 text-xs text-muted-foreground">
                <Loader2 className="size-3 animate-spin" aria-hidden /> Looking for students…
              </p>
            ) : mentionResults.length === 0 ? (
              <p className="px-3 py-2.5 text-xs text-muted-foreground">No student matches that username.</p>
            ) : (
              <ul className="max-h-56 overflow-y-auto py-1">
                {mentionResults.map((candidate, index) => (
                  <li key={candidate.id}>
                    <button
                      type="button"
                      role="option"
                      aria-selected={index === mentionIndex}
                      onMouseEnter={() => setMentionIndex(index)}
                      onClick={() => insertMention(candidate)}
                      className={cn(
                        "flex w-full items-center gap-2.5 px-3 py-2 text-left text-[0.8125rem]",
                        index === mentionIndex ? "bg-muted" : "hover:bg-muted/60",
                      )}
                    >
                      <Avatar src={candidate.avatarUrl} name={candidate.displayName} size="xs" />
                      <span className="min-w-0 flex-1 truncate">
                        <span className="font-medium">{candidate.displayName}</span>{" "}
                        <span className="text-muted-foreground">@{candidate.username}</span>
                      </span>
                    </button>
                  </li>
                ))}
              </ul>
            )}
          </div>
        ) : null}
      </div>

      {/* media preview */}
      {mediaPath ? (
        <div className="relative overflow-hidden rounded-xl border border-border">
          {/* Local uploads are served from /media; Supabase returns an absolute URL. */}
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={mediaPath} alt="Attachment preview" className="max-h-64 w-full object-cover" />
          <Button
            type="button"
            variant="primary"
            size="icon-sm"
            onClick={() => setMediaPath(null)}
            aria-label="Remove attached image"
            className="absolute right-2 top-2"
          >
            <X />
          </Button>
        </div>
      ) : null}

      {/* poll builder */}
      {showPoll ? (
        <div className="space-y-2 rounded-xl border border-border bg-muted/30 p-3">
          <div className="flex items-center justify-between">
            <p className="text-[0.8125rem] font-medium">Poll</p>
            <Button type="button" variant="ghost" size="icon-sm" onClick={() => setShowPoll(false)} aria-label="Remove poll">
              <Trash2 />
            </Button>
          </div>

          <Input
            value={poll.question}
            onChange={(event) => setPoll((current) => ({ ...current, question: event.target.value.slice(0, 200) }))}
            placeholder="Ask the community a question"
            aria-label="Poll question"
            maxLength={200}
          />

          <div className="space-y-1.5">
            {poll.options.map((option, index) => (
              <div key={index} className="flex items-center gap-1.5">
                <Input
                  value={option}
                  onChange={(event) =>
                    setPoll((current) => ({
                      ...current,
                      options: current.options.map((value, i) => (i === index ? event.target.value.slice(0, 120) : value)),
                    }))
                  }
                  placeholder={`Option ${index + 1}`}
                  aria-label={`Poll option ${index + 1}`}
                  maxLength={120}
                />
                {poll.options.length > 2 ? (
                  <Button
                    type="button"
                    variant="ghost"
                    size="icon-sm"
                    aria-label={`Remove option ${index + 1}`}
                    onClick={() =>
                      setPoll((current) => ({ ...current, options: current.options.filter((_, i) => i !== index) }))
                    }
                  >
                    <X />
                  </Button>
                ) : null}
              </div>
            ))}
          </div>

          {poll.options.length < 6 ? (
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => setPoll((current) => ({ ...current, options: [...current.options, ""] }))}
            >
              <Plus /> Add option
            </Button>
          ) : null}
        </div>
      ) : null}

      {error ? <InlineAlert tone="danger">{error}</InlineAlert> : null}

      {/* toolbar */}
      <div className="flex flex-wrap items-center gap-2 border-t border-border pt-3">
        <label className="inline-flex cursor-pointer items-center gap-1.5 rounded-lg px-2 py-1.5 text-[0.8125rem] text-muted-foreground transition-colors hover:bg-muted hover:text-foreground">
          {uploading ? <Loader2 className="size-4 animate-spin" aria-hidden /> : <ImagePlus className="size-4" aria-hidden />}
          <span>{uploading ? "Uploading…" : "Photo"}</span>
          <input
            type="file"
            accept="image/jpeg,image/png,image/webp,image/gif"
            className="sr-only"
            onChange={handleFile}
            disabled={uploading}
          />
        </label>

        {!showPoll ? (
          <Button type="button" variant="ghost" size="sm" onClick={() => setShowPoll(true)} className="gap-1.5">
            <BarChart3 /> Poll
          </Button>
        ) : null}

        <Button
          type="button"
          variant="ghost"
          size="sm"
          onClick={() => setPreview(true)}
          disabled={body.trim().length === 0}
          className="gap-1.5"
        >
          <Eye /> Preview
        </Button>

        <span
          id="composer-counter"
          aria-live="polite"
          className={cn(
            "ml-auto text-xs tabular-nums",
            remaining < 0 ? "font-medium text-danger" : remaining < 200 ? "text-warning" : "text-muted-foreground",
          )}
        >
          {remaining < 200 ? `${remaining} left` : `${compactNumber(body.length)}/${POST_MAX_LENGTH}`}
        </span>

        <Button type="button" variant="outline" size="sm" onClick={handleSaveDraft} disabled={isPending || body.length === 0}>
          <Save /> Save draft
        </Button>

        <Button type="submit" size="sm" loading={isPending} loadingLabel="Publishing…" disabled={!canSubmit}>
          <Send /> {isAnonymous ? "Post anonymously" : "Post"}
        </Button>
      </div>

      <p className="flex items-start gap-1.5 text-xs text-muted-foreground">
        <Info className="mt-0.5 size-3 shrink-0" aria-hidden />
        <span>
          Anonymous posts hide your identity from students, but they are not untraceable. Hate speech, threats and
          doxxing are removed and can lead to a ban.
        </span>
      </p>
    </form>
  );

  const previewDialog = (
    <Dialog open={preview} onOpenChange={setPreview}>
      <DialogContent title="Preview" description="This is how your post will appear in the feed.">
        <article className="surface p-4">
          <header className="flex items-center gap-3">
            <Avatar
              src={isAnonymous ? null : currentUser.avatarUrl}
              name={isAnonymous ? "Anonymous" : currentUser.displayName}
              anonymous={isAnonymous}
              size="md"
            />
            <div>
              <p className="text-[0.8125rem] font-semibold">
                {isAnonymous ? "Anonymous" : currentUser.displayName}
              </p>
              <p className="flex items-center gap-1.5 text-xs text-muted-foreground">
                {isAnonymous ? (
                  <Badge variant="neutral" size="sm">
                    <EyeOff className="size-2.5" /> Anonymous
                  </Badge>
                ) : (
                  <span>@{currentUser.username}</span>
                )}
                <span>· {selectedChannel?.label ?? "No community"}</span>
              </p>
            </div>
          </header>

          <p className="mt-3 whitespace-pre-wrap break-words text-[0.9375rem] leading-[1.65]">{body}</p>

          {mediaPath ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img src={mediaPath} alt="" className="mt-3 max-h-72 w-full rounded-lg object-cover" />
          ) : null}

          {showPoll && poll.question ? (
            <div className="mt-3 rounded-xl border border-border bg-muted/30 p-3 text-[0.8125rem]">
              <p className="font-medium">{poll.question}</p>
              <ul className="mt-2 space-y-1">
                {poll.options.filter(Boolean).map((option, index) => (
                  <li key={index} className="rounded-lg border border-border bg-card px-3 py-1.5">
                    {option}
                  </li>
                ))}
              </ul>
            </div>
          ) : null}

          <p className="mt-3 flex items-center gap-3 border-t border-border pt-3 text-xs text-muted-foreground">
            <span>♡ 0</span>
            <span>💬 0</span>
            <span className="ml-auto">
              <Users className="inline size-3" aria-hidden /> {selectedChannel?.label}
            </span>
          </p>
        </article>
      </DialogContent>
    </Dialog>
  );

  if (variant === "dialog") {
    return (
      <>
        <Dialog open={open} onOpenChange={setOpen}>
          <DropdownMenu>
            <DropdownMenuTrigger asChild>{trigger}</DropdownMenuTrigger>
            <DropdownMenuContent className="w-64">
              <DropdownMenuLabel>Create</DropdownMenuLabel>
              <DropdownMenuItem onSelect={() => { setIsAnonymous(true); setOpen(true); }}>
                <EyeOff /> Anonymous confession
              </DropdownMenuItem>
              <DropdownMenuItem onSelect={() => { setIsAnonymous(false); setOpen(true); }}>
                <Eye /> Public post
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>

          <DialogContent
            title={isAnonymous ? "New anonymous confession" : "New post"}
            description="Confessions are reviewed against the community guidelines."
            className="max-w-2xl"
          >
            {panel}
          </DialogContent>
        </Dialog>
        {previewDialog}
      </>
    );
  }

  return (
    <div className="surface p-4 sm:p-5">
      <div className="mb-3 flex items-center gap-2">
        <Hash className="size-4 text-muted-foreground" aria-hidden />
        <h2 className="text-[0.9375rem] font-semibold">Write a confession</h2>
        <Badge variant="subtle" size="sm" className="ml-auto">
          {isAnonymous ? "Anonymous" : "Public"}
        </Badge>
      </div>
      {panel}
      {previewDialog}
    </div>
  );
}
