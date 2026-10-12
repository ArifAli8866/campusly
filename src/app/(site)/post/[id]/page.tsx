import { redirect } from "next/navigation";

export default async function PostAliasRedirect({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  redirect(`/p/${id}`);
}
