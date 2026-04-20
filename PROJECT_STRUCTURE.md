# LTMS Project Structure

LTMS is a multi-app logistics platform for importing goods from international marketplaces into the Kurdistan Region of Iraq.

The repository is organized as a small monorepo: one Laravel API, four Flutter apps, and shared Dart packages used by those apps.

```text
ltms/
+-- .github/                         # GitHub workflows and repository automation
+-- docker/                          # Docker build assets and Nginx configs
+-- packages/                        # Shared Dart packages used by Flutter apps
|   +-- pj_api_client/               # Dio API client and auth interceptors
|   +-- pj_domain/                   # Shared models and domain types
|   +-- pj_l10n/                     # English/Kurdish localization package
|   +-- pj_shared_ui/                # Shared UI helpers and locale state
+-- pj_backend/                      # Laravel API
|   +-- app/
|   |   +-- Http/Controllers/        # API controllers
|   |   +-- Http/Requests/           # Request validation and authorization
|   |   +-- Models/                  # Eloquent models
|   |   +-- Services/                # Business logic services
|   +-- database/
|   |   +-- migrations/              # Database schema changes
|   |   +-- seeders/                 # Default catalog, users, demo data
|   +-- routes/api.php               # Versioned API routes
|   +-- tests/Feature/               # Backend feature tests
+-- pj_admin/                        # Flutter web app for admins
|   +-- lib/src/
|       +-- core/                    # Routing, API provider, theme, shell
|       +-- features/                # Admin feature modules
+-- pj_staff/                        # Flutter web app for staff
|   +-- lib/src/
|       +-- core/
|       +-- features/
+-- pj_customer/                     # Flutter web/mobile app for customers
|   +-- lib/src/
|       +-- core/
|       +-- features/                # Marketplace import ordering lives here
+-- pj_driver/                       # Flutter app for drivers
|   +-- lib/src/
|       +-- core/
|       +-- features/
+-- scripts/                         # Local helper scripts
+-- docker-compose.yml               # Full local/Coolify stack
+-- docker-compose.*.yml             # Focused compose variants
+-- README.md                        # Setup and deployment guide
```

## Source Ownership

- Backend API behavior belongs in `pj_backend/app`; validation belongs in `Http/Requests`, and reusable business rules belong in `Services`.
- Shared Flutter models belong in `packages/pj_domain`; app-specific UI state belongs inside that app's `lib/src/features`.
- Network calls belong in `packages/pj_api_client`; apps should consume the shared client through their local `core/api_provider.dart`.
- Kurdish and English UI text should use `packages/pj_l10n` when the text is shared or reused. One-off screen text can remain local only when it is tightly scoped.

## Files Kept Out Of Git

The repository intentionally excludes generated artifacts and local machine state:

- Flutter build output: `build/`, `.dart_tool/`, platform ephemeral folders
- Local IDE metadata: `.vscode/`, `.idea/`, `*.iml`
- Local logs, temp files, screenshots, and analysis dumps
- Local installers/downloads: `.downloads/`, `*.exe`
- Local secrets: `pj_backend/.env`

Do not commit nested repository copies, installer binaries, screenshots from manual testing, or generated cache folders.
