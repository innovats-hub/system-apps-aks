# Create namespace argocd in cluster
resource "kubernetes_namespace" "namespace-argocd" {
  metadata {
    name = "argocd"
  }
}

# Deploy Argocd in cluster
resource "helm_release" "argocd" {
  count            = var.argocd_enabled == true ? 1 : 0
  name             = var.argocd_resource_name
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  namespace        = kubernetes_namespace.namespace-argocd.metadata[0].name
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  set {
    name  = "configs.params.\"server.insecure\""
    value = var.argocd_server_insecure_enabled
  }

  set {
    name  = "global.domain"
    value = var.argocd_domain
  }
}