variable "datadog_api_key" {
  type = string
  sensitive = true
}

variable "datadog_app_key" {
  type = string
  sensitive = true
}

variable "datadog_site" {
  type = string
  default = "datadoghq.eu"
}