output "dashboard_id" {
  description = "Datadog overview dashboard id."
  value       = var.enable_dashboard ? datadog_dashboard_json.overview[0].id : null
}

output "synthetic_health_test_id" {
  description = "Synthetic health test id."
  value       = datadog_synthetics_test.app_health.id
}

output "slo_ids" {
  description = "Created Datadog SLO ids."
  value = {
    customer_availability = var.enable_slos ? datadog_service_level_objective.customer_availability[0].id : null
    report_generation     = var.enable_slos && var.enable_log_monitors ? datadog_service_level_objective.report_generation_quality[0].id : null
    official_dependency   = var.enable_slos && var.enable_log_monitors ? datadog_service_level_objective.official_dependency_health[0].id : null
  }
}
