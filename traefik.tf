# Create namespace Traefik in cluster
resource "kubernetes_namespace" "namespace-traefik" {
  metadata {
    name = "traefik"
  }
}

# Deploy Traefik in cluster
resource "helm_release" "traefik" {
  count            = var.traefik_enabled == true ? 1 : 0
  name             = var.traefik_resource_name
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  version          = var.traefik_version
  namespace        = kubernetes_namespace.namespace-traefik.name
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  values = [
    "${file("values/traefik.yml")}"
  ]

  set {
    name = "ingressClass.name"
    value = var.traefik_ingressclass_name
  }

  depends_on = [kubernetes_namespace.namespace-traefik]
}