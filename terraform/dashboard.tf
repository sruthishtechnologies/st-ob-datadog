resource "datadog_dashboard_json" "overview" {
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
          content = "## SriSatVam report store\nWatch customer availability first, then report workflow quality, official portal dependencies, PDF/downloads, and storage. SLO/error budget widgets below point to the most important user journeys."
        }
      },
      {
        definition = {
          type      = "slo"
          title     = "Customer availability SLO"
          slo_id    = datadog_service_level_objective.customer_availability.id
          view_type = "detail"
        }
      },
      {
        definition = {
          type      = "slo"
          title     = "Report generation quality SLO"
          slo_id    = datadog_service_level_objective.report_generation_quality.id
          view_type = "detail"
        }
      },
      {
        definition = {
          type      = "slo"
          title     = "Official portal dependency SLO"
          slo_id    = datadog_service_level_objective.official_dependency_health.id
          view_type = "detail"
        }
      },
      {
        definition = {
          type  = "timeseries"
          title = "API request volume"
          requests = [
            {
              q            = "sum:trace.http.request.hits{service:$service,env:$env}.as_count()"
              display_type = "bars"
            }
          ]
        }
      },
      {
        definition = {
          type  = "timeseries"
          title = "API p95 latency"
          requests = [
            {
              q            = "p95:trace.http.request.duration{service:$service,env:$env}"
              display_type = "line"
            }
          ]
        }
      },
      {
        definition = {
          type  = "query_value"
          title = "API 5xx errors"
          requests = [
            {
              q          = "sum:trace.http.request.errors{service:$service,env:$env}.as_count()"
              aggregator = "sum"
            }
          ]
          precision = 0
        }
      },
      {
        definition = {
          type    = "log_stream"
          title   = "Recent report workflow errors"
          query   = "service:$service env:$env (error OR failed OR timeout)"
          columns = ["status", "service", "message"]
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
