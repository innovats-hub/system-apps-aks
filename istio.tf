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
  namespace        = kubernetes_namespace.namespace-istio.metadata[0].name
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
  namespace        = kubernetes_namespace.namespace-istio.metadata[0].name
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