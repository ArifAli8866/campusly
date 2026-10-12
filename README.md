# 🎓 Campusly — Campus Community & Confession Platform

[![Next.js 15](https://img.shields.io/badge/Next.js-15.5-black?style=flat-square&logo=next.js)](https://nextjs.org/)
[![React 19](https://img.shields.io/badge/React-19-blue?style=flat-square&logo=react)](https://react.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-blue?style=flat-square&logo=typescript)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-3.4-38B2AC?style=flat-square&logo=tailwind-css)](https://tailwindcss.com/)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL_%26_Auth-3ECF8E?style=flat-square&logo=supabase)](https://supabase.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-purple?style=flat-square)](LICENSE)

**Campusly** is a privacy-first campus social and confession web platform built specifically for universities across Pakistan. It combines verified student communities, campus-wide discussion channels, and strict cryptographic anonymity for confessions and sensitive student conversations.

---

## 🌟 Key Features

- 🕵️ **Strict Anonymous Confessions**: Anonymity is guaranteed at the database engine layer. Author identities for anonymous confessions are completely stripped inside PostgreSQL RPC functions so the client never receives identity tokens.
- 🏫 **Comprehensive University Catalogue**: Verified directories for top Pakistani universities (NUST, FAST-NUCES, LUMS, IBA Karachi, COMSATS, UET Lahore, GIKI, PIEAS, and more) across all regional campuses.
- 💬 **Campus Community Channels**: Dedicated discussion spaces per university and campus covering Confessions, Academics, Career Advice, Campus Life, Housing & Hostels, and Lost & Found.
- 🧭 **Multi-Scope Search & Explore**: Real-time fuzzy search across posts, universities, campuses, channels, and fellow students.
- 🛡️ **Community Moderation Queue**: In-depth moderation dashboard for handling harassment reports, safety triage, doxxing prevention, and content filtering.
- 🎨 **Nexuma-Inspired Modern UI**: Responsive design featuring floating pill navigation, soft shadows, rounded surfaces, dark/light themes, and mobile navigation sheets.
- ⚡ **Next.js 15 App Router & Server Actions**: Zero-client-waterfall server rendering, streaming UI, and instant database mutations via Server Actions.

---

## 🛠️ Tech Stack

- **Framework**: Next.js 15 (App Router with Turbopack support)
- **Library**: React 19
- **Language**: TypeScript 5 (Strict Mode)
- **Styling**: Tailwind CSS + `lucide-react` icons
- **Database & Auth**: Supabase (PostgreSQL 15+, Row Level Security, Auth, Storage)
- **Embedded Local Mode**: `@electric-sql/pglite` (Zero-config local development without external dependencies)
- **Deployment**: Vercel

---

## 📋 Table of Contents

1. [Local Development Setup](#-local-development-setup)
2. [Supabase Database Setup Guide](#-supabase-database-setup-guide)
3. [Google OAuth Configuration Guide](#-google-oauth-configuration-guide)
4. [Environment Variables Reference](#-environment-variables-reference)
5. [Vercel Deployment Guide](#-vercel-deployment-guide)
6. [Security & Anonymity Architecture](#-security--anonymity-architecture)

---

## 💻 Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/ArifAli8866/campusly.git
cd campusly
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Configure Environment Variables

Copy `.env.example` to `.env.local`:

```bash
cp .env.example .env.local
```

Fill in your configuration keys (see [Environment Variables Reference](#-environment-variables-reference)).

### 4. Start Development Server

```bash
npm run dev
```

Visit [http://localhost:3000](http://localhost:3000) in your browser.

---

## 🗄️ Supabase Database Setup Guide

Follow this step-by-step guide to configure your live PostgreSQL database on [Supabase](https://supabase.com).

### Step 1: Create a Supabase Project

1. Log into your [Supabase Dashboard](https://supabase.com/dashboard).
2. Click **New Project**.
3. Choose an Organization, Name your project (e.g., `campusly-prod`), set a strong Database Password, and select the region closest to your users (e.g., `Singapore (ap-southeast-1)` or `Frankfurt (eu-central-1)`).
4. Click **Create new project** and wait ~2 minutes for provisioning.

---

### Step 2: Run SQL Migrations in Order

Open the **SQL Editor** in your Supabase project sidebar. You will copy and paste the contents of the following files from this repository in **EXACT ORDER**:

#### 📄 Script 1: Database Schema
- **File**: `supabase/migrations/0001_schema.sql`
- **What it does**:
  - Creates core tables: `profiles`, `universities`, `campuses`, `channels`, `channel_members`, `posts`, `comments`, `likes`, `bookmarks`, `reports`, `moderation_actions`.
  - Configures indexes, foreign keys, timestamps, and status enums.
- **Action**: Copy all contents of `supabase/migrations/0001_schema.sql`, paste into the Supabase SQL Editor, and click **RUN**.

#### 📄 Script 2: PostgreSQL Functions & RPCs
- **File**: `supabase/migrations/0002_functions.sql`
- **What it does**:
  - Creates stored procedures including `feed_posts`, `trending_topics`, `discover_users`, `channel_detail`, `moderation_queue`, and anonymity sanitization routines.
  - Implements deanonymization audit logs strictly restricted to administrators.
- **Action**: Copy all contents of `supabase/migrations/0002_functions.sql`, paste into the Supabase SQL Editor, and click **RUN**.

#### 📄 Script 3: Row Level Security (RLS) Policies
- **File**: `supabase/migrations/0003_rls.sql`
- **What it does**:
  - Enables Row Level Security on all tables.
  - Grants public read access for published confessions and verified campus channels.
  - Restricts insert/update permissions so students can only modify their own posts, comments, likes, and profiles.
- **Action**: Copy all contents of `supabase/migrations/0003_rls.sql`, paste into the Supabase SQL Editor, and click **RUN**.

#### 📄 Script 4: Storage Bucket & Upload Policies
- **File**: `supabase/migrations/0004_storage.sql`
- **What it does**:
  - Creates the public `media` storage bucket for post attachments and avatars.
  - Enforces file size limits (max 5MB) and permitted MIME types (`image/jpeg`, `image/png`, `image/webp`).
- **Action**: Copy all contents of `supabase/migrations/0004_storage.sql`, paste into the Supabase SQL Editor, and click **RUN**.

#### 📄 Script 5: Notification Triggers
- **File**: `supabase/migrations/0005_notifications.sql`
- **What it does**:
  - Creates notification tables and triggers for likes, replies, comments, and mentions.
  - Automatically notifies authors without compromising anonymity.
- **Action**: Copy all contents of `supabase/migrations/0005_notifications.sql`, paste into the Supabase SQL Editor, and click **RUN**.

#### 📄 Script 6: Seed University & Campus Catalogue
- **File**: `supabase/seed/seed.sql`
- **What it does**:
  - Seeds official data for Pakistani universities (NUST, FAST, LUMS, IBA, COMSATS, UET, GIKI, PIEAS, etc.), their respective regional campuses, and default campus community channels.
- **Action**: Copy all contents of `supabase/seed/seed.sql`, paste into the Supabase SQL Editor, and click **RUN**.

#### 📄 Script 7 (Optional): Starter Demo Feed
- **File**: `supabase/seed/demo.sql`
- **What it does**:
  - Populates realistic starter confessions, questions, and replies across campuses for testing.
- **Action**: *(Optional)* Copy and run `supabase/seed/demo.sql` if you want pre-populated feed content.

---

## 🔑 Google OAuth Configuration Guide

To enable "Continue with Google" sign-in:

### Step 1: Create OAuth Credentials in Google Cloud Console

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project or select an existing one (e.g., `Campusly`).
3. Navigate to **APIs & Services** > **OAuth consent screen**:
   - User Type: **External** -> Click **Create**.
   - App Name: `Campusly`
   - User Support Email: your email address
   - Developer Contact Information: your email address
   - Save and Continue through Scopes (`.../auth/userinfo.email`, `.../auth/userinfo.profile`, `openid`).
4. Navigate to **APIs & Services** > **Credentials**:
   - Click **+ CREATE CREDENTIALS** > **OAuth client ID**.
   - Application type: **Web application**.
   - Name: `Campusly Auth`.
   - **Authorized JavaScript origins**:
     - `http://localhost:3000`
     - `https://your-app-name.vercel.app` *(add after deploying to Vercel)*
   - **Authorized redirect URIs**:
     - `https://<YOUR_SUPABASE_PROJECT_REF>.supabase.co/auth/v1/callback`
       *(Find your Project Reference ID in your Supabase Project Settings > General)*
5. Click **Create** and copy your **Client ID** and **Client Secret**.

---

### Step 2: Configure Google Provider in Supabase

1. In your [Supabase Dashboard](https://supabase.com/dashboard), navigate to **Authentication** > **Providers**.
2. Click on **Google** to expand its settings:
   - Toggle **Enable Google provider** to ON.
   - Paste your **Client ID**.
   - Paste your **Client Secret**.
   - Click **Save**.
3. In **Authentication** > **URL Configuration**:
   - **Site URL**: `https://your-app-name.vercel.app` (or `http://localhost:3000` during local testing).
   - **Redirect URLs**: Add the following patterns:
     - `http://localhost:3000/**`
     - `https://your-app-name.vercel.app/**`
     - `https://*-your-team.vercel.app/**` *(for preview deployments)*

---

## ⚙️ Environment Variables Reference

Create a `.env.local` file in the root directory:

| Variable | Description | Example / Default |
| :--- | :--- | :--- |
| `NEXT_PUBLIC_SITE_URL` | Canonical URL of your deployment | `http://localhost:3000` or `https://campusly.vercel.app` |
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase Project URL | `https://xyzprojectref.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase public anonymous API key | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase private service role key (server-only) | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |
| `NEXT_PUBLIC_DEMO_MODE` | Toggle demo fallback mode | `false` |

> 🔒 **Security Notice**: Never commit `SUPABASE_SERVICE_ROLE_KEY` to public version control. It bypasses Row Level Security and is only used by protected server-side administrative actions.

---

## 🚀 Vercel Deployment Guide

Deploying Campusly to Vercel takes less than 3 minutes:

### Step 1: Push Code to GitHub

Your code is pushed to [https://github.com/ArifAli8866/campusly](https://github.com/ArifAli8866/campusly).

### Step 2: Import Project in Vercel

1. Log into [Vercel](https://vercel.com).
2. Click **Add New...** > **Project**.
3. Select your GitHub repository: `ArifAli8866/campusly`.
4. Framework Preset: **Next.js** (automatically detected).
5. Root Directory: `./`.

### Step 3: Add Environment Variables in Vercel

Under **Environment Variables**, add the four production keys:

1. `NEXT_PUBLIC_SITE_URL`: `https://your-project.vercel.app`
2. `NEXT_PUBLIC_SUPABASE_URL`: `https://<YOUR-PROJECT-REF>.supabase.co`
3. `NEXT_PUBLIC_SUPABASE_ANON_KEY`: `your-anon-key`
4. `SUPABASE_SERVICE_ROLE_KEY`: `your-service-role-key`

### Step 4: Deploy

1. Click **Deploy**.
2. Once the build completes (~1 minute), Vercel will assign you a production URL (e.g., `https://campusly.vercel.app`).
3. Copy your live Vercel URL and update:
   - **Google Cloud Console**: Add your Vercel URL to *Authorized JavaScript origins*.
   - **Supabase Auth**: Update *Site URL* and *Redirect URLs* with your live Vercel domain.

---

## 🛡️ Security & Anonymity Architecture

1. **Zero Client Leakage**:
   When a user posts anonymously (`is_anonymous = true`), the author's user ID and profile information are nullified inside Postgres stored functions before returning data to the API layer. Inspecting network requests in Chrome DevTools reveals zero author identifiers.

2. **Deanonymization Safeguards**:
   Author data can only be accessed under emergency circumstances (severe safety/legal threats) through an audited function (`audit_deanonymise`) that logs the administrator's ID, the reason, and an immutable timestamp into `moderation_actions`.

3. **Row Level Security (RLS)**:
   Every table enforces strict RLS policies in Postgres. A malicious client attempting direct API calls cannot modify or delete content belonging to other students.

4. **Input Sanitization**:
   All user input is validated using Zod schemas on the server before database execution.

---

## 👨‍💻 Author & Contributions

Built with ❤️ by **Arif Ali** ([@ArifAli8866](https://github.com/ArifAli8866))  
Email: [2arif2143055@gmail.com](mailto:2arif2143055@gmail.com)  
Repository: [https://github.com/ArifAli8866/campusly](https://github.com/ArifAli8866/campusly)
