# SriSatVam Observability Runbook

## API 5xx Alert

1. Open the overview dashboard.
2. Check whether errors are isolated to one route or all routes.
3. Check recent deploys in the app and infra repos.
4. Check logs for official portal errors, AWS errors, or Playwright/PDF errors.
5. If only official portal calls are failing, enable or update the customer notice in the admin section.

## Report Workflow Error Alert

1. Identify the report type: Full Legal Report, RTC Downloads, MR Downloader, Katha Validation, Village Scan, or AutoGen.
2. Check latency and timeout trends.
3. Check dependent portals:
   - Bhoomi Service2
   - MR Service11
   - Katha Service64
   - eChawadi
   - Akarband/Bhoomojini
4. Validate whether saved reports and PDF rendering still work.

## PDF Render Alert

1. Check app logs for Playwright, Chromium, font, or package errors.
2. Confirm the Docker image contains Playwright and Kannada fonts.
3. Test `/api/render-pdf` from the UI.
4. If Kannada rendering regresses, verify `Noto Sans Kannada` is installed in the image.

## Storage Alert

1. Check DynamoDB and S3 permissions for the EC2 instance role.
2. Check AWS region and bucket/table names.
3. Confirm saved reports list/load/save and archive download.

## Official Portal Dependency Alert

1. Run the app's Portal Health Monitor.
2. Compare failures across Bhoomi, eChawadi, Service11, Service64, and Akarband.
3. If external portals are down, post admin notice so users understand reports may be delayed.
