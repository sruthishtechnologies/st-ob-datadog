# Monitoring Plan

## What We Are Monitoring

SriSatVam Report Store is a land-report workflow app. It has three reliability risks:

1. Customer-facing availability: users must be able to open the app, login, select land details, generate reports, and download PDFs.
2. Slow or failed report generation: several workflows call Karnataka official portals and may run for minutes.
3. External dependency instability: Bhoomi, eChawadi, MR, Katha, Akarband, OpenAI, Claude, S3, DynamoDB, and Playwright/Chromium can fail independently.

## SLIs

| SLI | Source | Why it matters |
|---|---|---|
| App availability | Synthetic `GET /api/health` and landing page | Fastest signal that customers can reach the service. |
| API 5xx errors | APM trace analytics | Shows server-side defects and dependency failures visible to users. |
| API p95 latency | APM trace metrics | Shows degraded UX before hard failures occur. |
| Report workflow failure count | Logs/APM | Core business function: reports must complete. |
| PDF/download failure count | Logs | Customers rely on print/download output. |
| Official portal failure count | Logs | Separates our app issues from Bhoomi/eChawadi downtime. |
| Saved report storage failures | Logs | Users must not lose notes, statuses, saved reports, and archives. |

## SLOs And Error Budgets

| SLO | Target | Error Budget Meaning |
|---|---:|---|
| Customer availability | 99.5% over 7 days, 99.0% over 30 days | Page/API health outages are customer-visible and should be rare. |
| Report generation quality | 98.0% over 7 days, 97.0% over 30 days | Report generation depends on external portals, so the target is realistic but strict. |
| Official portal dependency health | 95.0% over 7 and 30 days | Tracks external portal instability separately so we can communicate clearly to users. |

SLOs are created only when `ENABLE_SLOS=true`. The report-generation and official-dependency SLOs also require `ENABLE_LOG_MONITORS=true`, because they depend on Datadog Logs.

## Dashboards

The overview dashboard is designed for first response:

- SLO/error budget widgets first, so owners know customer impact immediately.
- Request volume and p95 latency when APM monitors are enabled.
- API 5xx query value when APM monitors are enabled.
- Log stream for recent report workflow failures when Logs are enabled.
- Monitor status board for active alerts.

## Alerts

| Alert | Severity | Why configured |
|---|---|---|
| API 5xx rate high | Critical | Indicates app defects or unhandled dependency failures. |
| API p95 latency high | High | Report workflows can degrade before failing. |
| Report workflow errors | Critical | This is the core paid/customer value. |
| Official portal dependency failures | High | Needed for user messaging and root-cause separation. |
| PDF render/download failures | High | Previously failed due Playwright/fonts; high business impact. |
| Auth/admin error spike | Medium | Detects login, registration, and permission issues. |
| Saved report storage failures | High | Prevents loss of saved work and downloaded evidence folders. |

## API Inventory To Watch

### Core

- `GET /api/health`
- `GET /api/public-state`

### Auth And Admin

- `POST /api/auth/login`
- `POST /api/register`
- `POST /api/admin/state`
- `POST /api/admin/notice`
- `POST /api/admin/role`
- `POST /api/admin/approve-registration`
- `POST /api/admin/update-user`
- `POST /api/admin/reset-password`

### Land Selection

- `POST /api/start`
- `POST /api/select`
- `POST /api/go`
- `POST /api/fetch`

### Report Generation

- `POST /api/report`
- `POST /api/mr-downloader`
- `POST /api/village-scan`
- `POST /api/katha-validation`
- `POST /api/download-rtcs`
- `POST /api/scan-rtcs`

### AI And Output

- `POST /api/legal-report`
- `POST /api/claude-review`
- `POST /api/render-pdf`
- `POST /api/export-data`
- `GET /api/document/:id`

### Saved Reports

- `POST /api/saved-reports/save`
- `POST /api/saved-reports/list`
- `POST /api/saved-reports/load`
- `POST /api/saved-reports/archive`

### Dependency Health

- `POST /api/portal-health`

## Next App-Side Instrumentation

Terraform creates Datadog resources, but the app and EC2 host must emit telemetry:

1. Install/configure Datadog Agent on the EC2 host.
2. Run the app with `DD_SERVICE=ssvd-report-store`, `DD_ENV=prod`, and `DD_VERSION=<git-sha>`.
3. Enable Node.js tracing with `dd-trace` or Datadog auto-instrumentation.
4. Forward container logs to Datadog with service/env tags.
5. Add structured log fields for `route`, `status_code`, `duration_ms`, `portal`, `report_type`, and `session_id_hash`.

These app-side fields make the dashboards and monitors far more accurate.
