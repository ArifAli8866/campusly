import { redirect } from "next/navigation";

export default async function ShortChannelRedirect({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  redirect(`/channels/${slug}`);
}
