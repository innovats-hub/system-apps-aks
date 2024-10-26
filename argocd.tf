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

  values = [
    "${file("values/argocd.yml")}"
  ]

  set {
    name  = "global.domain"
    value = var.argocd_domain
  }

  depends_on = [kubernetes_namespace.namespace-argocd]
}

# Deploy Jaeger in cluster
resource "helm_release" "argocd_app_jaeger" {
  count            = var.argocd_apps_enabled == true ? 1 : 0
  name             = "${var.argocd_apps_resource_name}-jaeger"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = var.argocd_apps_version
  namespace        = kubernetes_namespace.namespace-argocd.metadata[0].name
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  values = [
    "${file("values/app-jaeger-argo.yml")}"
  ]

  depends_on = [helm_release.argocd]
}

# Deploy Kiali in cluster
resource "helm_release" "argocd_app_kiali" {
  count            = var.argocd_apps_enabled == true ? 1 : 0
  name             = "${var.argocd_apps_resource_name}-kiali"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = var.argocd_apps_version
  namespace        = kubernetes_namespace.namespace-argocd.metadata[0].name
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  values = [
    "${file("values/app-kiali-argo.yml")}"
  ]

  depends_on = [helm_release.argocd, helm_release.argocd_app_jaeger]
}

# Deploy Rancher in cluster
resource "helm_release" "argocd_app_rancher" {
  count            = var.argocd_apps_enabled == true ? 1 : 0
  name             = "${var.argocd_apps_resource_name}-rancher"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = var.argocd_apps_version
  namespace        = kubernetes_namespace.namespace-argocd.metadata[0].name
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  values = [
    "${file("values/app-rancher-argo.yml")}"
  ]

  depends_on = [helm_release.argocd]
}