output "dashboard_id" {
  description = "Datadog overview dashboard id."
  value       = datadog_dashboard_json.overview.id
}

output "synthetic_health_test_id" {
  description = "Synthetic health test id."
  value       = datadog_synthetics_test.app_health.id
}

output "slo_ids" {
  description = "Created Datadog SLO ids."
  value = {
    customer_availability = datadog_service_level_objective.customer_availability.id
    report_generation     = var.enable_log_monitors ? datadog_service_level_objective.report_generation_quality[0].id : null
    official_dependency   = var.enable_log_monitors ? datadog_service_level_objective.official_dependency_health[0].id : null
  }
}
