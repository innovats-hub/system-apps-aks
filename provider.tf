# Azure Provider
terraform {
  required_version = ">=1.7.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }

  backend "azurerm" {}
}

# Microsoft Azure Provider
provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "aks_credentials" {
  name                = var.azure_cluster_name
  resource_group_name = var.azure_resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.cluster_ca_certificate)
  }
}

provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_credentials.kube_config.0.cluster_ca_certificate)
  load_config_file       = false
}