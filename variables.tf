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

# Cert manager variables

variable "certmanager_enabled" {
  description = "Specifies whether Istio should be enabled in the Kubernetes cluster."
  type        = bool
  default     = false
}

variable "certmanager_version" {
  description = "The version of Istio to be installed or managed."
  type        = string
  default     = "1.16.1"
}

variable "certmanager_resource_name" {
  description = "The name of the Istio resource within the Kubernetes cluster."
  type        = string
  default     = "cert-manager"
}

# Lets encrypt variables

variable "letsencrypt_cloudflare_enabled" {
  description = "Enables or disables the Let's Encrypt ClusterIssuer configuration with Cloudflare DNS."
  type        = bool
  default     = false
}

variable "letsencrypt_cloudflare_token" {
  description = "Cloudflare authentication token for DNS validation in Let's Encrypt."
  type        = string
  sensitive   = true
  default     = "token"
}

variable "letsencrypt_cloudflare_email" {
  description = "Email address used for Let's Encrypt registration and certificate-related notifications."
  type        = string
  sensitive   = true
  default     = "name@example.com"
}

variable "letsencrypt_cloudflare_organization" {
  description = "Organization name associated with the issued certificate."
  type        = string
  default     = "example"
}

variable "letsencrypt_cloudflare_domain_zone" {
  description = "Domain zone in Cloudflare to be used for Let's Encrypt DNS (e.g., 'example.com')."
  type        = string
  default     = "example.com"
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

variable "argocd_domain" {
  description = "The domain name for accessing the ArgoCD server."
  type        = string
  default     = "argocd.example.com"
}

# Argocd apps variables

variable "argocd_apps_enabled" {
  description = "Specifies whether Argo apps should be enabled in the Kubernetes cluster."
  type        = bool
  default     = true
}

variable "argocd_apps_version" {
  description = "The version of Argo apps to be installed or managed."
  type        = string
  default     = "2.0.2"
}

variable "argocd_apps_resource_name" {
  description = "The name of the Argo apps resource within the Kubernetes cluster."
  type        = string
  default     = "argocd-app"
}