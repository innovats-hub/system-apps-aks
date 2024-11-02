# Deploy Argocd in cluster
resource "helm_release" "argocd" {
  count            = var.argocd_enabled == true ? 1 : 0
  name             = var.argocd_resource_name
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  namespace        = "argocd"
  create_namespace = true
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
}

resource "kubectl_manifest" "ingress_argocd" {
  count     = var.letsencrypt_cloudflare_enabled == true ? 1 : 0
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata:
  name: argocd
  namespace: ${helm_release.argocd[0].namespace}
spec:
  hosts:
    - "argocd.dev.${var.letsencrypt_cloudflare_domain_zone}"
  gateways:
    - "istio-system/${var.letsencrypt_cloudflare_organization}-dev"
  http:
    - match:
        - uri:
            prefix: /
      route:
        - destination:
            host: argocd-server
            port:
              number: 80
YAML

  depends_on = [
    helm_release.argocd,
    helm_release.istio_gateway,
    kubectl_manifest.gateway_ingress_dev
  ]
}

# Deploy Kiali in cluster
resource "helm_release" "argocd_app_kiali" {
  count            = var.argocd_apps_enabled == true ? 1 : 0
  name             = "${var.argocd_apps_resource_name}-kiali"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = var.argocd_apps_version
  namespace        = helm_release.argocd[0].namespace
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

  depends_on = [helm_release.argocd]
}

# Deploy Grafana in cluster
resource "helm_release" "argocd_app_grafana" {
  count            = var.argocd_apps_enabled == true ? 1 : 0
  name             = "${var.argocd_apps_resource_name}-grafana"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = var.argocd_apps_version
  namespace        = helm_release.argocd[0].namespace
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  values = [
    "${file("values/app-grafana-argo.yml")}"
  ]

  depends_on = [helm_release.argocd]
}

# Deploy repositories apps in cluster
resource "helm_release" "argocd_app_repositories" {
  count            = var.argocd_apps_enabled == true ? 1 : 0
  name             = "${var.argocd_apps_resource_name}-repositories"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = var.argocd_apps_version
  namespace        = helm_release.argocd[0].namespace
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  values = [
    "${file("values/app-repositories-argo.yml")}"
  ]

  depends_on = [helm_release.argocd, kubectl_manifest.gateway_ingress_dev]
}

# Deploy DNS apps in cluster
resource "helm_release" "argocd_app_dns" {
  count            = var.argocd_apps_enabled == true && var.letsencrypt_cloudflare_enabled == true ? 1 : 0
  name             = "${var.argocd_apps_resource_name}-dns"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = var.argocd_apps_version
  namespace        = helm_release.argocd[0].namespace
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  values = [
    "${file("values/app-dns-argo.yml")}"
  ]

  depends_on = [helm_release.argocd, kubectl_manifest.gateway_ingress_dev]
}