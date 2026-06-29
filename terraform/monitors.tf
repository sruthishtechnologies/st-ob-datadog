resource "datadog_monitor" "api_5xx_rate" {
  name    = "${local.app_name} - API 5xx rate is high"
  type    = "trace-analytics alert"
  message = local.monitor_message
  query   = "trace-analytics(\"service:${var.service_name} env:${var.environment} @http.status_code:[500 TO 599]\").rollup(\"count\").last(\"5m\") > 5"

  monitor_thresholds {
    warning  = 2
    critical = 5
  }

  include_tags        = true
  require_full_window = false
  priority            = var.alert_priority_critical
  validate            = false
  tags                = concat(local.tags, ["sli:availability", "surface:api"])
}

resource "datadog_monitor" "api_latency_p95" {
  name    = "${local.app_name} - API p95 latency is high"
  type    = "query alert"
  message = local.monitor_message
  query   = "percentile(last_10m):p95:trace.http.request.duration{service:${var.service_name},env:${var.environment}} > 5"

  monitor_thresholds {
    warning  = 3
    critical = 5
  }

  include_tags        = true
  require_full_window = false
  priority            = var.alert_priority_high
  validate            = false
  tags                = concat(local.tags, ["sli:latency", "surface:api"])
}

resource "datadog_monitor" "report_workflow_errors" {
  name    = "${local.app_name} - report workflow errors"
  type    = "log alert"
  message = local.monitor_message
  query   = "logs(\"service:${var.service_name} env:${var.environment} (\\\"/api/report\\\" OR \\\"/api/download-rtcs\\\" OR \\\"/api/mr-downloader\\\" OR \\\"/api/katha-validation\\\" OR \\\"/api/village-scan\\\" OR \\\"/api/scan-rtcs\\\" OR \\\"/api/render-pdf\\\") (error OR failed OR timeout)\").index(\"*\").rollup(\"count\").last(\"10m\") > 3"

  monitor_thresholds {
    warning  = 1
    critical = 3
  }

  include_tags        = true
  require_full_window = false
  priority            = var.alert_priority_critical
  validate            = false
  tags                = concat(local.tags, ["journey:report-generation", "sli:quality"])
}

resource "datadog_monitor" "official_portal_down" {
  name    = "${local.app_name} - official portal dependency failures"
  type    = "log alert"
  message = local.monitor_message
  query   = "logs(\"service:${var.service_name} env:${var.environment} (Bhoomi OR eChawadi OR Service2 OR Service11 OR Service64 OR landrecords.karnataka.gov.in) (HTTP 500 OR fetch failed OR timeout OR portal not working)\").index(\"*\").rollup(\"count\").last(\"15m\") > 5"

  monitor_thresholds {
    warning  = 2
    critical = 5
  }

  include_tags        = true
  require_full_window = false
  priority            = var.alert_priority_high
  validate            = false
  tags                = concat(local.tags, ["dependency:official-portals", "sli:dependency"])
}

resource "datadog_monitor" "pdf_render_failures" {
  name    = "${local.app_name} - PDF render/download failures"
  type    = "log alert"
  message = local.monitor_message
  query   = "logs(\"service:${var.service_name} env:${var.environment} (\\\"/api/render-pdf\\\" OR Playwright OR Chromium OR PDF) (error OR failed OR Cannot find package OR font)\").index(\"*\").rollup(\"count\").last(\"10m\") > 2"

  monitor_thresholds {
    warning  = 1
    critical = 2
  }

  include_tags        = true
  require_full_window = false
  priority            = var.alert_priority_high
  validate            = false
  tags                = concat(local.tags, ["journey:download", "component:pdf"])
}

resource "datadog_monitor" "auth_registration_errors" {
  name    = "${local.app_name} - auth/admin error spike"
  type    = "log alert"
  message = local.monitor_message
  query   = "logs(\"service:${var.service_name} env:${var.environment} (\\\"/api/auth/login\\\" OR \\\"/api/register\\\" OR \\\"/api/admin/\\\") (error OR Invalid OR required OR not approved)\").index(\"*\").rollup(\"count\").last(\"15m\") > 10"

  monitor_thresholds {
    warning  = 5
    critical = 10
  }

  include_tags        = true
  require_full_window = false
  priority            = var.alert_priority_medium
  validate            = false
  tags                = concat(local.tags, ["surface:auth-admin"])
}

resource "datadog_monitor" "saved_report_storage_errors" {
  name    = "${local.app_name} - saved report storage failures"
  type    = "log alert"
  message = local.monitor_message
  query   = "logs(\"service:${var.service_name} env:${var.environment} (DynamoDB OR S3 OR saved-reports OR export-data OR archive) (AccessDenied OR error OR failed OR timeout)\").index(\"*\").rollup(\"count\").last(\"10m\") > 2"

  monitor_thresholds {
    warning  = 1
    critical = 2
  }

  include_tags        = true
  require_full_window = false
  priority            = var.alert_priority_high
  validate            = false
  tags                = concat(local.tags, ["component:storage", "dependency:aws"])
}
