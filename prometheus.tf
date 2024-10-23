# Create namespace prometheus in cluster
resource "kubernetes_namespace" "namespace-prometheus" {
  metadata {
    name = "monitoring"
  }
}

# Deploy helm Prometheus in cluster
resource "helm_release" "prometheus" {
  count            = var.prometheus_enabled == true ? 1 : 0
  name             = var.prometheus_resource_name
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = var.prometheus_version
  namespace        = kubernetes_namespace.namespace-prometheus.metadata[0].name
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  depends_on = [kubernetes_namespace.namespace-prometheus]
}