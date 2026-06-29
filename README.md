# SriSatVam Datadog Observability

Terraform automation for monitoring `ssvd-report-store` in Datadog.

This repo manages:

- API and landing-page synthetics.
- Baseline synthetics, availability SLOs, and dashboards.
- Optional monitors for API errors, latency, report generation failures, official portal failures, PDF/download failures, auth/admin errors, and AWS storage failures after APM/Logs are enabled.
- SLOs and error budgets for customer availability, report generation quality, and official portal dependency health.
- An overview dashboard for operators and product owners.
- GitHub Actions for PR validation and main-branch deployment.

## Required GitHub Secrets

Add these secrets in `sruthishtechnologies/st-ob-datadog`:

| Secret | Purpose |
|---|---|
| `DATADOG_API_KEY` | Allows Terraform to create Datadog resources. |
| `DATADOG_APP_KEY` | Allows Terraform to create Datadog resources. |
| `AWS_GITHUB_ACTIONS_ROLE_ARN` | OIDC role used by Actions to read/write Terraform state in S3. |
| `TF_STATE_BUCKET` | Existing S3 bucket for Terraform state. |
| `TF_STATE_LOCK_TABLE` | Existing DynamoDB lock table for Terraform state. |

## Optional GitHub Variables

| Variable | Default | Purpose |
|---|---:|---|
| `APP_URL` | `http://65.0.49.217` | Public app URL checked by synthetics. |
| `AWS_REGION` | `ap-south-1` | Terraform state region. |
| `DATADOG_API_URL` | `https://api.datadoghq.com` | Datadog site API endpoint. |
| `DATADOG_NOTIFICATION_HANDLES` | empty | Alert target, for example `@slack-ops` or `@someone@example.com`. |
| `ENABLE_APM_MONITORS` | `false` | Set to `true` after Datadog APM traces are enabled for the app. |
| `ENABLE_LOG_MONITORS` | `false` | Set to `true` after Datadog Logs/Log Management is enabled for the org. |
| `ENVIRONMENT` | `prod` | Datadog `env` tag. |
| `SERVICE_NAME` | `ssvd-report-store` | Datadog service tag used by APM/log monitors. |
| `TEAM` | `srisatvam` | Owner tag. |

By default this repo creates synthetics, an availability SLO, and the overview dashboard. Log/APM monitors are opt-in because some Datadog organizations do not have Logs/APM enabled yet.

## Deploy Flow

1. Open a PR with Terraform changes.
2. PR workflow runs `terraform fmt`, `terraform init -backend=false`, and `terraform validate`.
3. Merge to `main`.
4. Deploy workflow initializes S3-backed Terraform state, plans, applies, and prints dashboard/SLO outputs.

## Important App Tags

Datadog monitors assume the app emits logs/traces with:

- `service:ssvd-report-store`
- `env:prod`
- `team:srisatvam`

Keep these tags aligned with the app/EC2 Datadog Agent configuration.
