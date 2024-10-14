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
  namespace        = "monitoring"
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  depends_on = [kubernetes_namespace.namespace-prometheus]
}

# Create namespace istio in cluster
resource "kubernetes_namespace" "namespace-istio" {
  metadata {
    name = "istio-system"
  }
}

# Deploy helm Istio Base in cluster
resource "helm_release" "istio_base" {
  count            = var.istio_enabled == true ? 1 : 0
  name             = "${var.istio_resource_name}-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = var.istio_version
  namespace        = "istio-system"
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }

  depends_on = [kubernetes_namespace.namespace-istio]
}

# Deploy helm IstioD in cluster
resource "helm_release" "istiod" {
  count            = var.istio_enabled == true ? 1 : 0
  name             = "${var.istio_resource_name}-istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  version          = var.istio_version
  namespace        = "istio-system"
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  set {
    name  = "telemetry.enabled"
    value = "true"
  }

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }

  set {
    name  = "meshConfig.ingressService"
    value = "istio-gateway"
  }

  set {
    name  = "meshConfig.ingressSelector"
    value = "gateway"
  }

  depends_on = [helm_release.istio_base]
}

# Deploy helm Istio Gateway in cluster
resource "helm_release" "istio_gateway" {
  count            = var.istio_enabled == true ? 1 : 0
  name             = "${var.istio_resource_name}-gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  version          = var.istio_version
  namespace        = "istio-system"
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}