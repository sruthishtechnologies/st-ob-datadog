variable "datadog_api_key" {
  description = "Datadog API key used by GitHub Actions."
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog application key used by GitHub Actions."
  type        = string
  sensitive   = true
}

variable "datadog_api_url" {
  description = "Datadog API URL for the account site."
  type        = string
  default     = "https://api.datadoghq.com"
}

variable "environment" {
  description = "Deployment environment tag."
  type        = string
  default     = "prod"
}

variable "service_name" {
  description = "Datadog service name for the app."
  type        = string
  default     = "ssvd-report-store"
}

variable "team" {
  description = "Owning team tag."
  type        = string
  default     = "srisatvam"
}

variable "app_url" {
  description = "Public application URL used by synthetic checks."
  type        = string
  default     = "http://65.0.49.217"
}

variable "synthetic_locations" {
  description = "Datadog synthetic locations. Mumbai keeps checks close to Karnataka/Bhoomi portals."
  type        = list(string)
  default     = ["aws:ap-south-1"]
}

variable "synthetic_tick_every" {
  description = "Synthetic check frequency in seconds."
  type        = number
  default     = 300
}

variable "notification_handles" {
  description = "Datadog notification handles, for example @slack-channel or @email."
  type        = string
  default     = ""
}

variable "alert_priority_critical" {
  description = "Datadog critical monitor priority."
  type        = number
  default     = 1
}

variable "alert_priority_high" {
  description = "Datadog high monitor priority."
  type        = number
  default     = 2
}

variable "alert_priority_medium" {
  description = "Datadog medium monitor priority."
  type        = number
  default     = 3
}

variable "enable_apm_monitors" {
  description = "Create APM/trace monitors. Enable after Datadog APM is configured for the app service."
  type        = bool
  default     = false
}

variable "enable_log_monitors" {
  description = "Create log monitors. Enable only after Datadog Logs/Log Management is enabled for the organization."
  type        = bool
  default     = false
}

variable "enable_slos" {
  description = "Create Datadog SLOs after the baseline synthetic tests are stable."
  type        = bool
  default     = false
}

variable "enable_dashboard" {
  description = "Create the overview dashboard after baseline monitors/SLOs are stable."
  type        = bool
  default     = false
}
