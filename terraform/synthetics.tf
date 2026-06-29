resource "datadog_synthetics_test" "app_health" {
  type    = "api"
  subtype = "http"
  name    = "${local.app_name} - app health"
  message = local.monitor_message
  status  = "live"

  request_definition {
    method = "GET"
    url    = "${trimsuffix(var.app_url, "/")}/api/health"
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = "3000"
  }

  assertion {
    type     = "body"
    operator = "contains"
    target   = "\"ok\":true"
  }

  locations = var.synthetic_locations
  tags      = concat(local.tags, ["journey:health", "sli:availability"])

  options_list {
    tick_every           = var.synthetic_tick_every
    min_failure_duration = 0
    min_location_failed  = 1

    retry {
      count    = 2
      interval = 300
    }
  }
}

resource "datadog_synthetics_test" "landing_page" {
  type    = "api"
  subtype = "http"
  name    = "${local.app_name} - landing page"
  message = local.monitor_message
  status  = "live"

  request_definition {
    method = "GET"
    url    = trimsuffix(var.app_url, "/")
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = "5000"
  }

  locations = var.synthetic_locations
  tags      = concat(local.tags, ["journey:login-page", "sli:availability"])

  options_list {
    tick_every           = var.synthetic_tick_every
    min_failure_duration = 0
    min_location_failed  = 1

    retry {
      count    = 2
      interval = 300
    }
  }
}
