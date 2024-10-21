# Create namespace Cert manager in cluster
resource "kubernetes_namespace" "namespace-certmanager" {
  metadata {
    name = "cert-manager"
  }
}

# Deploy Cert manager in cluster
resource "helm_release" "certmanager" {
  count            = var.certmanager_enabled == true ? 1 : 0
  name             = var.certmanager_resource_name
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.certmanager_version
  namespace        = kubernetes_namespace.namespace-certmanager.name
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  values = [
    "${file("values/certmanager.yml")}"
  ]
}