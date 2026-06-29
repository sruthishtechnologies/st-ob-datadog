resource "datadog_service_level_objective" "customer_availability" {
  name        = "${local.app_name} - customer availability"
  type        = "monitor"
  description = "Customer-visible app availability from health and landing page synthetic checks."
  monitor_ids = [
    datadog_synthetics_test.app_health.monitor_id,
    datadog_synthetics_test.landing_page.monitor_id,
  ]

  thresholds {
    timeframe = "7d"
    target    = 99.5
    warning   = 99.7
  }

  thresholds {
    timeframe = "30d"
    target    = 99.0
    warning   = 99.5
  }

  tags = concat(local.tags, ["slo:customer-availability"])
}

resource "datadog_service_level_objective" "report_generation_quality" {
  name        = "${local.app_name} - report generation quality"
  type        = "monitor"
  description = "Report generation should complete without workflow, PDF, or storage failures."
  monitor_ids = [
    datadog_monitor.report_workflow_errors.id,
    datadog_monitor.pdf_render_failures.id,
    datadog_monitor.saved_report_storage_errors.id,
  ]

  thresholds {
    timeframe = "7d"
    target    = 98.0
    warning   = 99.0
  }

  thresholds {
    timeframe = "30d"
    target    = 97.0
    warning   = 98.5
  }

  tags = concat(local.tags, ["slo:report-generation"])
}

resource "datadog_service_level_objective" "official_dependency_health" {
  name        = "${local.app_name} - official portal dependency health"
  type        = "monitor"
  description = "Tracks failures from Bhoomi, eChawadi, MR, Katha, and related Karnataka portals."
  monitor_ids = [
    datadog_monitor.official_portal_down.id,
  ]

  thresholds {
    timeframe = "7d"
    target    = 95.0
    warning   = 97.0
  }

  thresholds {
    timeframe = "30d"
    target    = 95.0
    warning   = 97.0
  }

  tags = concat(local.tags, ["slo:official-dependencies"])
}
