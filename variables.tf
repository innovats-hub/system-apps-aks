# Default variables

variable "azure_environment" {
  description = "The environment for the Azure resources, such as 'dev', 'staging', 'hml', or 'prod'."
  type        = string
  default     = "dev"
}

variable "azure_cluster_name" {
  description = "The name of the Kubernetes cluster to be created."
  type        = string
  default     = "cluster-manager"
}

variable "azure_resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "infra-cluster-manager"
}


# Helm variables

variable "force_update" {
  description = "Forces the update of the release, even if there are no changes in the chart or values."
  type        = bool
  default     = false
}

variable "wait" {
  description = "Specifies whether Terraform should wait until all pods are ready before completing the deployment."
  type        = bool
  default     = true
}

variable "reuse_values" {
  description = "If set to true, reuse the values from the last release instead of using the provided values."
  type        = bool
  default     = false
}

variable "replace" {
  description = "If set to true, replace the existing release if a resource conflict error occurs during the update."
  type        = bool
  default     = false
}

variable "timeout" {
  description = "Specifies the maximum time (in seconds) Terraform should wait before cancelling the deployment operation."
  type        = number
  default     = 300
}

variable "disable_webhooks" {
  description = "If set to true, disables pre- and post-installation webhooks during the Helm deployment."
  type        = bool
  default     = false
}

variable "recreate_pods" {
  description = "If set to true, recreate pods even if configurations have not changed, useful to force pod rotation."
  type        = bool
  default     = false
}


# Prometheus variables

variable "prometheus_enabled" {
  description = "Specifies whether Prometheus should be enabled in the Kubernetes cluster."
  type        = bool
  default     = true
}

variable "prometheus_resource_name" {
  description = "The name of the Prometheus resource within the Kubernetes cluster."
  type        = string
  default     = "prometheus"
}

variable "prometheus_version" {
  description = "The version of Prometheus to be installed or managed."
  type        = string
  default     = "25.27.0"
}


# Istio variables

variable "istio_enabled" {
  description = "Specifies whether Istio should be enabled in the Kubernetes cluster."
  type        = bool
  default     = true
}

variable "istio_version" {
  description = "The version of Istio to be installed or managed."
  type        = string
  default     = "1.23.2"
}

variable "istio_resource_name" {
  description = "The name of the Istio resource within the Kubernetes cluster."
  type        = string
  default     = "istio"
}

# Traefik variables

variable "traefik_enabled" {
  description = "Specifies whether Traefik should be enabled in the Kubernetes cluster."
  type        = bool
  default     = true
}

variable "traefik_version" {
  description = "The version of Traefik to be installed or managed."
  type        = string
  default     = "32.1.1"
}

variable "traefik_resource_name" {
  description = "The name of the Traefik resource within the Kubernetes cluster."
  type        = string
  default     = "traefik"
}

# Argocd variables

variable "argocd_enabled" {
  description = "Specifies whether Argo should be enabled in the Kubernetes cluster."
  type        = bool
  default     = true
}

variable "argocd_version" {
  description = "The version of Argo to be installed or managed."
  type        = string
  default     = "7.6.12"
}

variable "argocd_resource_name" {
  description = "The name of the Argo resource within the Kubernetes cluster."
  type        = string
  default     = "argocd"
}