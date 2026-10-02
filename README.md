# PrepExami Flutter

Flutter mobile client converted from the existing Next.js application. The Next.js app remains the backend for AI processing, document extraction, payments, and webhooks; Flutter handles authentication and user-facing study flows.

## Run locally

Start Next.js from the repository root, then run Flutter with public runtime configuration:

```powershell
flutter run `
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLIC_ANON_KEY `
  --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

Use `http://localhost:3000` for Windows/web targets and the machine's LAN IP for a physical phone. `10.0.2.2` is the Android emulator alias for the host machine.

Never add the Supabase service-role key, OpenAI key, Paddle secret, or SMTP credentials to Flutter. They must stay in the server environment.

## Included flows

- Branded landing page and email authentication
- Supabase session persistence
- Document library with counts and pull-to-refresh
- File, URL, and pasted-text ingestion through the Next.js API
- Curriculum-to-chapter practice selector
- Profile and sign out

## Verify

```powershell
flutter analyze
flutter test
```
