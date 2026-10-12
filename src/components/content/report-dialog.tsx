"use client";

import { useState, useTransition } from "react";
import { ShieldCheck } from "lucide-react";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Field, InlineAlert, NativeSelect, Textarea } from "@/components/ui/fields";
import { Dialog, DialogContent, DialogTrigger } from "@/components/ui/overlays";
import { REPORT_REASONS } from "@/lib/constants";
import { reportContentAction } from "@/server/actions/social";

export function ReportDialog({
  targetType,
  targetId,
  trigger,
}: {
  targetType: "post" | "comment" | "user";
  targetId: string;
  trigger: React.ReactNode;
}) {
  const [open, setOpen] = useState(false);
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);

  function submit(formData: FormData) {
    setError(null);
    startTransition(async () => {
      const result = await reportContentAction(formData);
      if (!result.ok) {
        setError(result.error);
        return;
      }
      toast.success(result.message ?? "Report sent.");
      setOpen(false);
    });
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>{trigger}</DialogTrigger>
      <DialogContent
        title="Report to moderators"
        description="Reports are reviewed by the community's moderation team. Abuse of reporting is itself a violation."
      >
        <form action={submit} className="space-y-4">
          <input type="hidden" name="targetType" value={targetType} />
          <input type="hidden" name="targetId" value={targetId} />

          <Field label="What is wrong?" htmlFor="report-reason">
            <NativeSelect id="report-reason" name="reason" required defaultValue="harassment">
              {REPORT_REASONS.map((reason) => (
                <option key={reason.value} value={reason.value}>
                  {reason.label} — {reason.description}
                </option>
              ))}
            </NativeSelect>
          </Field>

          <Field
            label="Anything else the moderators should know?"
            htmlFor="report-description"
            optional
            hint="Do not include personal information about anyone. Attach no screenshots containing private details."
          >
            <Textarea id="report-description" name="description" rows={4} maxLength={1000} />
          </Field>

          {error ? <InlineAlert tone="danger">{error}</InlineAlert> : null}

          <div className="flex items-start gap-2 rounded-lg bg-muted/50 px-3 py-2.5 text-xs text-muted-foreground">
            <ShieldCheck className="mt-0.5 size-3.5 shrink-0" aria-hidden />
            <p>
              Moderators can see the reported content, but they cannot see who wrote an anonymous confession unless
              they formally request disclosure — which is logged and reviewed.
            </p>
          </div>

          <div className="flex justify-end gap-2">
            <Button type="button" variant="outline" size="sm" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button type="submit" size="sm" loading={isPending} loadingLabel="Sending…">
              Send report
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}
