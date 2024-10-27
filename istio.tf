# Deploy helm Istio Base in cluster
resource "helm_release" "istio_base" {
  count            = var.istio_enabled == true ? 1 : 0
  name             = "${var.istio_resource_name}-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = var.istio_version
  namespace        = "istio-system"
  create_namespace = true
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
}

# Deploy helm IstioD in cluster
resource "helm_release" "istiod" {
  count            = var.istio_enabled == true ? 1 : 0
  name             = "${var.istio_resource_name}-istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  version          = var.istio_version
  namespace        = helm_release.istio_base[0].namespace
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

resource "helm_release" "istio_gateway" {
  count            = var.istio_enabled == true ? 1 : 0
  name             = "${var.istio_resource_name}-gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  version          = var.istio_version
  namespace        = helm_release.istio_base[0].namespace
  force_update     = var.force_update
  wait             = var.wait
  reuse_values     = var.reuse_values
  replace          = var.replace
  timeout          = var.timeout
  disable_webhooks = var.disable_webhooks
  recreate_pods    = var.recreate_pods

  depends_on = [helm_release.istio_base, helm_release.istiod]
}

resource "kubernetes_manifest" "gateway_ingress_dev" {
  count = var.letsencrypt_cloudflare_enabled == true ? 1 : 0
  manifest = {
    "apiVersion" = "networking.istio.io/v1"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = "${var.letsencrypt_cloudflare_organization}_dev"
      "namespace" = "${helm_release.istio_base[0].namespace}"
    }
    "spec" = {
      "selector" = {
        "istio" = "gateway"
      }
      "servers" = [
        {
          "hosts" = ["*.dev.${var.letsencrypt_cloudflare_domain_zone}"]
          "port" = {
            "name"     = "http"
            "number"   = 80
            "protocol" = "HTTP"
          }
          "tls" = {
            "httpsRedirect" = true
          }
        },
        {
          "hosts" = ["*.dev.${var.letsencrypt_cloudflare_domain_zone}"]
          "port" = {
            "number"   = 443
            "name"     = "https"
            "protocol" = "HTTPS"
          }
          "tls" = {
            "mode"           = "SIMPLE"
            "credentialName" = "wildcard-dev-${var.letsencrypt_cloudflare_organization}-com-tls"
          }
        }
      ]
    }
  }

  depends_on = [
    helm_release.certmanager,
    helm_release.istio_gateway,
    kubernetes_manifest.letsencrypt_certificate_wildcard_dev
  ]
}