# Interactive Learn

Interactive Learn is a Flutter + Supabase app for structured technical learning.

Hierarchy used in content:

Subject -> Chapter -> Topic -> Subtopic -> Slides

Slide sources:

- slide (markdown content)
- slide_mcq (multiple-choice)
- slide_match (match pairs)

## Tech Stack

- Flutter (Material 3)
- Supabase (auth + PostgreSQL)
- Riverpod + Hooks
- Freezed + JSON serialization
- flutter_dotenv
- flutter_markdown_plus
- logger

## Current Feature Status

### Auth

- Email/password signup and login
- Session-driven routing via AuthGate
- Logout from Profile

### Learning Flow

- Subject -> chapter -> topic -> subtopic navigation
- Slide viewer supports content, MCQ, and match slides
- Ordered lesson progression and interaction gating

### Profile and Related Settings

- Profile overview includes:
  - display name
  - email
  - bio
  - member since
  - short user id
- Manage Profile page:
  - edit display name and bio
  - save to Supabase auth user metadata
- Theme settings:
  - app-wide ThemeMode updates
  - persisted in user metadata
- Notification settings:
  - toggles persisted in user metadata
- Danger Zone:
  - delete account request flow with confirmation
  - writes deletion request metadata and signs user out

## Key Files

- App boot and theme wiring: lib/main.dart
- Profile tab: lib/screens/tabs/profile_screen.dart
- Manage profile: lib/screens/tabs/manage_profile_page.dart
- Theme settings: lib/screens/tabs/theme_settings_page.dart
- Notification settings: lib/screens/tabs/notifications_settings_page.dart
- Profile widgets:
  - lib/screens/tabs/widgets/profile_header.dart
  - lib/screens/tabs/widgets/profile_about_card.dart
  - lib/screens/tabs/widgets/profile_settings_card.dart
  - lib/screens/tabs/widgets/profile_danger_zone_card.dart
  - lib/screens/tabs/widgets/profile_logout_tile.dart
- Providers:
  - lib/core/providers/auth_provider.dart
  - lib/core/providers/theme_provider.dart
  - lib/core/providers/notifications_provider.dart

## Setup

Create a .env file in the project root:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

Install and run:

```bash
flutter pub get
dart run build_runner build -d
flutter run
```

## Validation Commands

```bash
flutter analyze
flutter test
```

Latest local validation status for this change set:

- flutter analyze: pass
- flutter test: pass

## Notes

- Profile preferences are currently stored in Supabase auth user metadata.
- Delete account is implemented as a request flow (metadata flag + sign out), not direct hard delete from client.
