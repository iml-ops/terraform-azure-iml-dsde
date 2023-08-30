variable "name" {
  type        = string
  description = "The name of the deployment. This will be used for naming resources."
  default     = "iml-dsde"
}

variable "location" {
  type        = string
  description = "The Azure region to deploy to."
  default     = "eastus"
}

variable "network_cidr" {
  type        = string
  description = "The CIDR block assigned by InfiniaML to this deployment."
}

variable "boundary_cluster_id" {
  type        = string
  description = "The ID of the Boundary cluster."
}

variable "gateway_token" {
  type        = string
  description = "The token for the gateway."
}

variable "sensitve_scopes" {
  type       = list(string)
  description = "The list of scopes that should be considered sensitive and granted to Data Scientists only when authorized."
}