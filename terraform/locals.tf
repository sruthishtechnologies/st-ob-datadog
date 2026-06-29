locals {
  app_name = "SriSatVam Bhoomi Report Store"

  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "team:${var.team}",
    "managed_by:terraform",
    "repo:st-ob-datadog",
    "app:ssvd-report-store",
  ]

  monitor_message = trimspace(join("\n", [
    "{{#is_alert}}Investigate ${local.app_name}. Start with the dashboard, recent deploy, app logs, and dependent Karnataka portals.{{/is_alert}}",
    "{{#is_warning}}Warning threshold crossed for ${local.app_name}. Check trend before it becomes customer-visible.{{/is_warning}}",
    var.notification_handles,
  ]))

  critical_user_apis = [
    "/api/health",
    "/api/start",
    "/api/select",
    "/api/fetch",
    "/api/report",
    "/api/render-pdf",
    "/api/download-rtcs",
    "/api/mr-downloader",
    "/api/saved-reports/save",
  ]

  report_workflow_apis = [
    "/api/report",
    "/api/download-rtcs",
    "/api/mr-downloader",
    "/api/katha-validation",
    "/api/village-scan",
    "/api/scan-rtcs",
    "/api/legal-report",
    "/api/claude-review",
    "/api/render-pdf",
  ]
}
