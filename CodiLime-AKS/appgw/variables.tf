# Global Variables

variable "resource_group_name" {}
variable "location" {}
#variable "azurerm_subnet" {}
variable "waf_subnet" {}


variable "wafip_id" {
  description = "The ID of the Public IP address resource"
  type        = string
}

########################################################################################################################

#  frontdoor

variable "frontdoor_name" {}
variable "routing_rule_name" {}
variable "accepted_protocols" { type = list(string) }
variable "patterns_to_match" { type = list(string) }
variable "frontend_endpoints" { type = list(string) }
#variable "forwarding_protocol" {}
variable "backend_pool_name" {}
variable "backend_pool_load_balancing_name" {}
variable "backend_pool_health_probe_name" {}
variable "backend_host_header" {}
variable "backend_address" {}
variable "backend_http_port" { type = number }
variable "backend_https_port" { type = number }
variable "frontend_endpoint_name" {}
variable "frontend_endpoint_host_name" {}

