resource "datadog_dashboard_json" "overview" {
  count = var.enable_dashboard ? 1 : 0

  dashboard = jsonencode({
    title       = "${local.app_name} - Observability Overview"
    description = "Availability, report generation, official portal dependencies, PDF/download health, and storage health."
    layout_type = "ordered"
    tags        = local.tags
    template_variables = [
      {
        name    = "env"
        prefix  = "env"
        default = var.environment
      },
      {
        name    = "service"
        prefix  = "service"
        default = var.service_name
      }
    ]
    widgets = [
      {
        definition = {
          type    = "note"
          content = "## SriSatVam report store\nCurrent baseline monitors customer availability with synthetics and SLOs. Enable APM/log monitors after Datadog APM and Logs are configured for the app service."
        }
      },
      {
        definition = {
          type      = "slo"
          title     = "Customer availability SLO"
          slo_id    = datadog_service_level_objective.customer_availability[0].id
          view_type = "detail"
        }
      },
      {
        definition = {
          type             = "manage_status"
          title            = "Critical monitors"
          query            = "service:${var.service_name} env:${var.environment}"
          display_format   = "countsAndList"
          color_preference = "background"
          hide_zero_counts = true
        }
      }
    ]
  })
}
