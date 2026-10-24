# SimpleSite Website Builder

A customer portal for the ₹1,999 simple website service. Customers create an account, complete a business and SEO brief, select brand colours, upload a logo, generate a page preview, and download the generated HTML. Domain purchase/renewal is excluded from the ₹1,999 service.

## Stack

- Static HTML/CSS/JS frontend with a Vercel serverless config endpoint.
- Supabase Auth for customer accounts.
- Supabase Postgres + Row Level Security for customer briefs.
- Supabase Storage for uploaded logos.
- Data-driven one-page website generation with page title, description, keywords, Open Graph metadata, and LocalBusiness JSON-LD.
- Vercel + GitHub for hosting and automatic deployments.

## Backend setup

1. Connect the Supabase plugin and create a project.
2. Apply `supabase/schema.sql` in that project's SQL editor.
3. Set the Vercel project environment variables from `.env.example` (`SUPABASE_URL` and the public publishable key only). Never put a Supabase secret/service-role key in the browser or these variables.
4. Configure Supabase Auth email redirects to the Vercel deployment origin.
5. Deploy and confirm registration, email confirmation, sign-in, saving, logo upload, and preview generation.

Until those environment variables and the SQL schema are configured, the landing page works but registration and data persistence remain disabled.

## Deployment

Connect the GitHub repository to a Vercel project. The repository root is the project root; it has no build command. Vercel deploys each push to the production branch and creates previews for other branches.

## Offer notes

- Domain registration and renewal are extra.
- The current flow generates a draft/preview; it does not charge customers, publish customer sites, or buy domains automatically.
- Before enabling payments or customer publishing, add the agreed payment gateway, ownership review, and per-customer delivery process.
