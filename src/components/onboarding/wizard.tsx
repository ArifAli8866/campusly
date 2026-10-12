"use client";

import { useRouter } from "next/navigation";
import { useEffect, useMemo, useState, useTransition } from "react";
import {
  ArrowLeft,
  ArrowRight,
  Check,
  GraduationCap,
  IdCard,
  Layers,
  Palette,
  Search,
  Shield,
  Sparkles,
  UserRound,
} from "lucide-react";
import { toast } from "sonner";

import { JoinButton } from "@/components/content/join-button";
import { Avatar, Badge, EmptyState, Skeleton } from "@/components/ui/primitives";
import { Button } from "@/components/ui/button";
import { Field, InlineAlert, Input, NativeSelect, Textarea } from "@/components/ui/fields";
import { Label, Switch } from "@/components/ui/primitives";
import { INTERESTS } from "@/lib/constants";
import type { CampusChoice, RecommendedChannel, UniversityChoice } from "@/lib/db/types";
import { cn, normaliseUsername, pluralize } from "@/lib/utils";
import { completeOnboardingAction, saveBasicsAction, savePreferencesAction, saveUniversityAction } from "@/server/actions/onboarding";
import { checkUsernameAction } from "@/server/actions/profile";

const STEPS = [
  { id: 1, label: "About you", icon: UserRound },
  { id: 2, label: "Your university", icon: GraduationCap },
  { id: 3, label: "Preferences", icon: Palette },
  { id: 4, label: "Communities", icon: Layers },
] as const;

export interface OnboardingWizardProps {
  userId: string;
  initialStep: number;
  profile: {
    displayName: string;
    username: string;
    bio: string;
    avatarUrl: string | null;
    universityId: string | null;
    campusId: string | null;
    country: string;
    degreeProgram: string;
    department: string;
    semester: string;
    graduationYear: string;
    profileVisibility: "public" | "university" | "private";
    interests: string[];
  };
  notifications: {
    mentions: boolean;
    comments: boolean;
    replies: boolean;
    likes: boolean;
    channelActivity: boolean;
    productUpdates: boolean;
  };
  universities: UniversityChoice[];
  recommended: RecommendedChannel[];
  totalUniversities: number;
}

export function OnboardingWizard(props: OnboardingWizardProps) {
  const router = useRouter();
  const [step, setStep] = useState(Math.min(Math.max(props.initialStep, 0) + 1, 4));
  const [isPending, startTransition] = useTransition();

  // ---- step 1 -------------------------------------------------------------
  const [displayName, setDisplayName] = useState(props.profile.displayName);
  const [username, setUsername] = useState(props.profile.username);
  const [bio, setBio] = useState(props.profile.bio);
  const [usernameState, setUsernameState] = useState<"idle" | "checking" | "free" | "taken" | "invalid">("idle");

  // ---- step 2 -------------------------------------------------------------
  const [universities, setUniversities] = useState(props.universities);
  const [universityQuery, setUniversityQuery] = useState("");
  const [universityId, setUniversityId] = useState(props.profile.universityId ?? "");
  const [campuses, setCampuses] = useState<CampusChoice[]>([]);
  const [campusId, setCampusId] = useState(props.profile.campusId ?? "");
  const [campusesLoading, setCampusesLoading] = useState(false);
  const [country] = useState(props.profile.country || "Pakistan");
  const [degreeProgram, setDegreeProgram] = useState(props.profile.degreeProgram);
  const [department, setDepartment] = useState(props.profile.department);
  const [semester, setSemester] = useState(props.profile.semester);
  const [graduationYear, setGraduationYear] = useState(props.profile.graduationYear);

  // ---- step 3 -------------------------------------------------------------
  const [profileVisibility, setProfileVisibility] = useState(props.profile.profileVisibility);
  const [interests, setInterests] = useState<string[]>(props.profile.interests);
  const [notifications, setNotifications] = useState(props.notifications);

  // ---- step 4 -------------------------------------------------------------
  const [recommended, setRecommended] = useState(props.recommended);

  const selectedUniversity = useMemo(
    () => universities.find((u) => u.id === universityId) ?? null,
    [universities, universityId],
  );

  /* -------------------------------------------------- username availability */
  useEffect(() => {
    const normalised = normaliseUsername(username);
    if (normalised.length < 3 || normalised !== username) {
      setUsernameState(username.length === 0 ? "idle" : "invalid");
      return;
    }
    if (normalised === props.profile.username) {
      setUsernameState("free");
      return;
    }

    setUsernameState("checking");
    const timer = setTimeout(async () => {
      const result = await checkUsernameAction(normalised);
      setUsernameState(result.ok && result.data?.available ? "free" : "taken");
    }, 320);

    return () => clearTimeout(timer);
  }, [username, props.profile.username]);

  /* ---------------------------------------------------- university searching */
  useEffect(() => {
    if (universityQuery.trim().length === 0) {
      setUniversities(props.universities);
      return;
    }
    let cancelled = false;
    const timer = setTimeout(async () => {
      const response = await fetch(`/api/universities?q=${encodeURIComponent(universityQuery)}`);
      if (cancelled) return;
      const data = (await response.json()) as { universities: UniversityChoice[] };
      setUniversities(data.universities ?? []);
    }, 260);

    return () => {
      cancelled = true;
      clearTimeout(timer);
    };
  }, [universityQuery, props.universities]);

  /* ------------------------------------------------------------- campuses */
  useEffect(() => {
    if (!universityId) {
      setCampuses([]);
      return;
    }
    let cancelled = false;
    setCampusesLoading(true);

    fetch(`/api/campuses?universityId=${encodeURIComponent(universityId)}`)
      .then((response) => response.json() as Promise<{ campuses: CampusChoice[] }>)
      .then((data) => {
        if (cancelled) return;
        setCampuses(data.campuses ?? []);
        // Preselect the main campus so the common case needs no extra tap.
        setCampusId((current) => {
          if (current && data.campuses.some((c) => c.id === current)) return current;
          return data.campuses.find((c) => c.is_main)?.id ?? data.campuses[0]?.id ?? "";
        });
      })
      .finally(() => !cancelled && setCampusesLoading(false));

    return () => {
      cancelled = true;
    };
  }, [universityId]);

  /* -------------------------------------------------------------- navigation */

  function persistStep(target: number) {
    return new Promise<boolean>((resolve) => {
      startTransition(async () => {
        let result;

        if (step === 1) {
          if (displayName.trim().length === 0) {
            toast.error("Add a display name to continue.");
            resolve(false);
            return;
          }
          if (usernameState === "taken" || usernameState === "invalid") {
            toast.error("Choose an available username to continue.");
            resolve(false);
            return;
          }
          const formData = new FormData();
          formData.set("displayName", displayName);
          formData.set("username", normaliseUsername(username));
          formData.set("bio", bio);
          result = await saveBasicsAction(formData);
        } else if (step === 2) {
          if (!universityId) {
            toast.error("Choose your university to continue.");
            resolve(false);
            return;
          }
          const formData = new FormData();
          formData.set("universityId", universityId);
          formData.set("campusId", campusId);
          formData.set("country", country);
          formData.set("degreeProgram", degreeProgram);
          formData.set("department", department);
          formData.set("semester", semester);
          formData.set("graduationYear", graduationYear);
          result = await saveUniversityAction(formData);
        } else if (step === 3) {
          const formData = new FormData();
          formData.set("bio", bio);
          formData.set("profileVisibility", profileVisibility);
          formData.set("interests", JSON.stringify(interests));
          formData.set("notifications", JSON.stringify(notifications));
          result = await savePreferencesAction(formData);
        } else {
          resolve(true);
          return;
        }

        if (!result.ok) {
          toast.error(result.error);
          resolve(false);
          return;
        }

        setStep(target);
        resolve(true);
      });
    });
  }

  function finish() {
    startTransition(async () => {
      const result = await completeOnboardingAction();
      if (!result.ok) {
        toast.error(result.error);
        return;
      }
      toast.success(result.message ?? "You are all set.");
      router.push("/home");
      router.refresh();
    });
  }

  /* ------------------------------------------------------------------ render */

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:py-12">
      {/* stepper */}
      <ol className="mb-6 flex items-center gap-1.5" aria-label="Setup progress">
        {STEPS.map((item, index) => {
          const state = item.id < step ? "done" : item.id === step ? "current" : "upcoming";
          return (
            <li key={item.id} className="flex flex-1 items-center gap-1.5">
              <div className="flex min-w-0 flex-1 items-center gap-2">
                <span
                  className={cn(
                    "flex size-7 shrink-0 items-center justify-center rounded-full text-[0.6875rem] font-semibold transition-colors",
                    state === "done" && "bg-success text-white",
                    state === "current" && "bg-primary text-primary-foreground",
                    state === "upcoming" && "bg-muted text-muted-foreground",
                  )}
                  aria-current={state === "current" ? "step" : undefined}
                >
                  {state === "done" ? <Check className="size-3.5" /> : item.id}
                </span>
                <span
                  className={cn(
                    "hidden truncate text-xs font-medium sm:block",
                    state === "upcoming" ? "text-muted-foreground" : "text-foreground",
                  )}
                >
                  {item.label}
                </span>
              </div>
              {index < STEPS.length - 1 ? (
                <span className={cn("h-px flex-1", state === "done" ? "bg-success" : "bg-border")} aria-hidden />
              ) : null}
            </li>
          );
        })}
      </ol>

      <div className="surface p-6 sm:p-8">
        {/* ------------------------------------------------------ step 1 */}
        {step === 1 ? (
          <section className="space-y-5">
            <header>
              <Badge variant="outline">
                <IdCard className="size-3" aria-hidden /> Step 1
              </Badge>
              <h1 className="mt-3 text-2xl font-semibold tracking-[-0.025em]">Who are you on Campusly?</h1>
              <p className="mt-1.5 text-sm text-muted-foreground">
                Your display name and username are only shown on posts you choose to publish publicly.
              </p>
            </header>

            <div className="flex items-center gap-4">
              <Avatar src={props.profile.avatarUrl} name={displayName || "You"} size="xl" />
              <div className="text-sm">
                <p className="font-medium">Profile photo is optional</p>
                <p className="mt-0.5 text-xs text-muted-foreground">
                  You can add one later in settings. Anonymous posts never show it.
                </p>
              </div>
            </div>

            <Field label="Display name" htmlFor="ob-name" hint="Shown on your profile and public posts.">
              <Input
                id="ob-name"
                value={displayName}
                onChange={(event) => setDisplayName(event.target.value.slice(0, 60))}
                maxLength={60}
                required
                autoComplete="name"
              />
            </Field>

            <Field
              label="Username"
              htmlFor="ob-username"
              error={usernameState === "taken" ? "That username is already taken." : usernameState === "invalid" ? "3–24 characters: letters, numbers and underscores." : undefined}
              hint={usernameState === "free" ? "Available." : "This is how classmates mention you with @."}
            >
              <div className="relative">
                <span className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-sm text-muted-foreground">
                  @
                </span>
                <Input
                  id="ob-username"
                  value={username}
                  onChange={(event) => setUsername(normaliseUsername(event.target.value).slice(0, 24))}
                  className="pl-7"
                  maxLength={24}
                  autoComplete="username"
                  aria-invalid={usernameState === "taken" || usernameState === "invalid"}
                />
                <span className="absolute right-3 top-1/2 -translate-y-1/2">
                  {usernameState === "checking" ? <Skeleton className="size-3.5 rounded-full" /> : null}
                  {usernameState === "free" ? <Check className="size-4 text-success" aria-hidden /> : null}
                </span>
              </div>
            </Field>

            <Field label="Short introduction" htmlFor="ob-bio" optional hint="Up to 300 characters.">
              <Textarea
                id="ob-bio"
                value={bio}
                onChange={(event) => setBio(event.target.value.slice(0, 300))}
                maxLength={300}
                rows={3}
                placeholder="Second-year CS student, football on Fridays, always looking for study partners."
              />
            </Field>
          </section>
        ) : null}

        {/* ------------------------------------------------------ step 2 */}
        {step === 2 ? (
          <section className="space-y-5">
            <header>
              <Badge variant="outline">
                <GraduationCap className="size-3" aria-hidden /> Step 2
              </Badge>
              <h1 className="mt-3 text-2xl font-semibold tracking-[-0.025em]">Where do you study?</h1>
              <p className="mt-1.5 text-sm text-muted-foreground">
                We use this to recommend your campus community. Nothing here is shown publicly unless you choose a
                public profile.
              </p>
            </header>

            <Field label="Search universities" htmlFor="ob-uni-search" hint={`${props.totalUniversities} institutions in the catalogue.`}>
              <div className="relative">
                <Search className="pointer-events-none absolute left-3 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" aria-hidden />
                <Input
                  id="ob-uni-search"
                  value={universityQuery}
                  onChange={(event) => setUniversityQuery(event.target.value)}
                  placeholder="FAST, NUST, LUMS, Peshawar…"
                  className="pl-9"
                />
              </div>
            </Field>

            <Field label="University" htmlFor="ob-university">
              <NativeSelect
                id="ob-university"
                value={universityId}
                onChange={(event) => setUniversityId(event.target.value)}
                required
              >
                <option value="">Choose your university</option>
                {universities.map((university) => (
                  <option key={university.id} value={university.id}>
                    {university.name}
                    {university.abbreviation ? ` (${university.abbreviation})` : ""}
                    {university.city ? ` — ${university.city}` : ""}
                  </option>
                ))}
              </NativeSelect>
            </Field>

            {universities.length === 0 ? (
              <InlineAlert tone="info">
                No university matches that search. Try the abbreviation, or the city name.
              </InlineAlert>
            ) : null}

            <Field
              label="Campus"
              htmlFor="ob-campus"
              hint={
                campusesLoading
                  ? "Loading campuses…"
                  : selectedUniversity
                    ? `${pluralize(campuses.length, "campus", "campuses")} for ${selectedUniversity.name}.`
                    : "Choose a university first."
              }
            >
              <NativeSelect
                id="ob-campus"
                value={campusId}
                onChange={(event) => setCampusId(event.target.value)}
                disabled={!universityId || campusesLoading}
              >
                <option value="">{campusesLoading ? "Loading…" : "Choose your campus"}</option>
                {campuses.map((campus) => (
                  <option key={campus.id} value={campus.id}>
                    {campus.name}
                    {campus.city ? ` — ${campus.city}` : ""}
                  </option>
                ))}
              </NativeSelect>
            </Field>

            <div className="grid gap-4 sm:grid-cols-2">
              <Field label="Country" htmlFor="ob-country">
                <Input id="ob-country" value={country} readOnly className="bg-muted/50" />
              </Field>

              <Field label="Province or region" htmlFor="ob-province" optional hint="Taken from your campus.">
                <Input
                  id="ob-province"
                  value={campuses.find((c) => c.id === campusId)?.province ?? ""}
                  readOnly
                  className="bg-muted/50"
                  placeholder="—"
                />
              </Field>

              <Field label="Degree or programme" htmlFor="ob-degree" optional>
                <Input
                  id="ob-degree"
                  value={degreeProgram}
                  onChange={(event) => setDegreeProgram(event.target.value.slice(0, 120))}
                  placeholder="BS Computer Science"
                />
              </Field>

              <Field label="Department" htmlFor="ob-department" optional>
                <Input
                  id="ob-department"
                  value={department}
                  onChange={(event) => setDepartment(event.target.value.slice(0, 120))}
                  placeholder="Faculty of Computing"
                />
              </Field>

              <Field label="Current semester or year" htmlFor="ob-semester" optional>
                <Input
                  id="ob-semester"
                  value={semester}
                  onChange={(event) => setSemester(event.target.value.slice(0, 40))}
                  placeholder="4th semester"
                />
              </Field>

              <Field label="Graduation year" htmlFor="ob-graduation" optional>
                <Input
                  id="ob-graduation"
                  type="number"
                  min={1950}
                  max={2100}
                  value={graduationYear}
                  onChange={(event) => setGraduationYear(event.target.value)}
                  placeholder="2027"
                />
              </Field>
            </div>

            <InlineAlert tone="info" title="We do not ask for student IDs">
              Campusly never asks for a student ID, CNIC, fee receipt or a password for any other service.
            </InlineAlert>
          </section>
        ) : null}

        {/* ------------------------------------------------------ step 3 */}
        {step === 3 ? (
          <section className="space-y-5">
            <header>
              <Badge variant="outline">
                <Palette className="size-3" aria-hidden /> Step 3
              </Badge>
              <h1 className="mt-3 text-2xl font-semibold tracking-[-0.025em]">How should your profile behave?</h1>
              <p className="mt-1.5 text-sm text-muted-foreground">
                You can change every one of these settings later.
              </p>
            </header>

            <Field label="Short bio" htmlFor="ob-bio2" optional hint={`${300 - bio.length} characters left.`}>
              <Textarea
                id="ob-bio2"
                value={bio}
                onChange={(event) => setBio(event.target.value.slice(0, 300))}
                maxLength={300}
                rows={3}
              />
            </Field>

            <fieldset className="space-y-2.5">
              <legend className="text-[0.8125rem] font-medium">Profile visibility</legend>
              {(
                [
                  { value: "public", label: "Public", body: "Anyone can find and view your profile." },
                  { value: "university", label: "University only", body: "Only students in your university communities can view the detail." },
                  { value: "private", label: "Private", body: "Only your name and avatar are visible. Your bio, course and interests stay hidden." },
                ] as const
              ).map((option) => (
                <label
                  key={option.value}
                  className={cn(
                    "flex cursor-pointer items-start gap-3 rounded-xl border p-3.5 transition-colors",
                    profileVisibility === option.value
                      ? "border-accent/40 bg-accent-subtle"
                      : "border-border hover:border-border-strong",
                  )}
                >
                  <input
                    type="radio"
                    name="visibility"
                    value={option.value}
                    checked={profileVisibility === option.value}
                    onChange={() => setProfileVisibility(option.value)}
                    className="mt-1 size-4 accent-[var(--accent)]"
                  />
                  <span>
                    <span className="block text-[0.8125rem] font-medium">{option.label}</span>
                    <span className="mt-0.5 block text-xs text-muted-foreground">{option.body}</span>
                  </span>
                </label>
              ))}
            </fieldset>

            <fieldset className="space-y-2.5">
              <legend className="text-[0.8125rem] font-medium">
                Interests <span className="font-normal text-muted-foreground">— optional, {interests.length}/12 selected</span>
              </legend>
              <div className="flex flex-wrap gap-1.5">
                {INTERESTS.map((interest) => {
                  const selected = interests.includes(interest.value);
                  return (
                    <button
                      key={interest.value}
                      type="button"
                      aria-pressed={selected}
                      onClick={() =>
                        setInterests((current) =>
                          selected
                            ? current.filter((value) => value !== interest.value)
                            : current.length >= 12
                              ? current
                              : [...current, interest.value],
                        )
                      }
                      className={cn(
                        "rounded-full border px-3 py-1.5 text-[0.8125rem] transition-colors",
                        selected
                          ? "border-accent bg-accent text-accent-foreground"
                          : "border-border bg-card text-muted-foreground hover:border-border-strong hover:text-foreground",
                      )}
                    >
                      {interest.label}
                    </button>
                  );
                })}
              </div>
            </fieldset>

            <fieldset className="space-y-1">
              <legend className="mb-2 text-[0.8125rem] font-medium">Notifications</legend>
              {(
                [
                  ["mentions", "When someone mentions me", "Posts and comments that use @yourname."],
                  ["comments", "When someone comments on my public post", "Never sent for anonymous posts."],
                  ["replies", "When someone replies to my comment", ""],
                  ["likes", "When someone likes my post or comment", ""],
                  ["channelActivity", "Weekly community summary", "A short digest, at most once a week."],
                  ["productUpdates", "Occasional product updates", "Rare, and never marketing to third parties."],
                ] as const
              ).map(([key, label, help]) => (
                <div key={key} className="flex items-center justify-between gap-4 border-b border-border py-2.5 last:border-0">
                  <div className="min-w-0">
                    <Label htmlFor={`notif-${key}`} className="text-[0.8125rem]">
                      {label}
                    </Label>
                    {help ? <p className="text-xs text-muted-foreground">{help}</p> : null}
                  </div>
                  <Switch
                    id={`notif-${key}`}
                    checked={notifications[key]}
                    onCheckedChange={(checked) => setNotifications((current) => ({ ...current, [key]: checked }))}
                  />
                </div>
              ))}
            </fieldset>
          </section>
        ) : null}

        {/* ------------------------------------------------------ step 4 */}
        {step === 4 ? (
          <section className="space-y-5">
            <header>
              <Badge variant="outline">
                <Sparkles className="size-3" aria-hidden /> Step 4
              </Badge>
              <h1 className="mt-3 text-2xl font-semibold tracking-[-0.025em]">Join a few communities</h1>
              <p className="mt-1.5 text-sm text-muted-foreground">
                Recommended from your university, campus and city. You can skip this and join later.
              </p>
            </header>

            {recommended.length === 0 ? (
              <EmptyState
                icon={Layers}
                title="No recommendations yet"
                description="You can browse every community from the Explore page once you are set up."
              />
            ) : (
              <ul className="space-y-2.5">
                {recommended.map((channel) => (
                  <li key={channel.channel_id} className="flex items-center gap-3 rounded-xl border border-border p-3.5">
                    <span className="flex size-11 shrink-0 items-center justify-center overflow-hidden rounded-xl border border-border bg-muted text-xs font-semibold">
                      {channel.university_logo_url ? (
                        // eslint-disable-next-line @next/next/no-img-element
                        <img src={channel.university_logo_url} alt="" className="size-full object-contain p-1" />
                      ) : (
                        (channel.university_abbreviation ?? channel.university_name).slice(0, 3).toUpperCase()
                      )}
                    </span>

                    <div className="min-w-0 flex-1">
                      <p className="truncate text-[0.8125rem] font-medium">
                        {channel.university_name}
                        {channel.campus_name && channel.campus_name !== "Main Campus" ? ` · ${channel.campus_name}` : ""}
                      </p>
                      <p className="mt-0.5 flex flex-wrap items-center gap-x-2 text-xs text-muted-foreground">
                        <Badge variant="subtle" size="sm">
                          {channel.reason}
                        </Badge>
                        <span>{channel.member_count} members</span>
                        <span>· {channel.post_count} posts</span>
                      </p>
                    </div>

                    <JoinButton
                      channelId={channel.channel_id}
                      channelSlug={channel.channel_slug}
                      isMember={channel.is_member}
                      signedIn
                      size="sm"
                      onChange={(joined) =>
                        setRecommended((current) =>
                          current.map((item) =>
                            item.channel_id === channel.channel_id ? { ...item, is_member: joined } : item,
                          ),
                        )
                      }
                    />
                  </li>
                ))}
              </ul>
            )}

            <InlineAlert tone="info" title="Joining is not a commitment">
              You can leave any community at any time and rejoin later. Anonymous posts stay anonymous either way.
            </InlineAlert>
          </section>
        ) : null}

        {/* ------------------------------------------------------ footer */}
        <div className="mt-8 flex flex-wrap items-center gap-2 border-t border-border pt-5">
          {step > 1 ? (
            <Button variant="ghost" size="sm" onClick={() => setStep(step - 1)} disabled={isPending}>
              <ArrowLeft /> Back
            </Button>
          ) : null}

          <span className="text-xs text-muted-foreground">
            Step {step} of 4
          </span>

          <div className="ml-auto flex items-center gap-2">
            {step === 4 ? (
              <>
                <Button variant="ghost" size="sm" onClick={finish} disabled={isPending}>
                  Skip for now
                </Button>
                <Button size="md" onClick={finish} loading={isPending} loadingLabel="Finishing…">
                  Finish setup <ArrowRight />
                </Button>
              </>
            ) : (
              <Button
                size="md"
                onClick={() => void persistStep(step + 1)}
                loading={isPending}
                loadingLabel="Saving…"
              >
                Continue <ArrowRight />
              </Button>
            )}
          </div>
        </div>

        <p className="mt-4 flex items-start gap-1.5 text-xs text-muted-foreground">
          <Shield className="mt-0.5 size-3 shrink-0" aria-hidden />
          Your progress is saved at every step, so you can close this tab and come back.
        </p>
      </div>
    </div>
  );
}
