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

resource "kubernetes_manifest" "cloudflare_secret_token" {
  count = var.letsencrypt_cloudflare_enabled == true ? 1 : 0
  manifest = {
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "cloudflare-secret-token"
      namespace = kubernetes_namespace.namespace-certmanager.name
    }
    type = "Opaque"
    stringData = {
      cloudflare-token = var.letsencrypt_cloudflare_token
    }
  }
}

resource "kubernetes_manifest" "letsencrypt_cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name      = var.letsencrypt_cloudflare_name
      namespace = kubernetes_namespace.namespace-certmanager.name
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = var.letsencrypt_cloudflare_email
        privateKeySecretRef = {
          name = var.letsencrypt_cloudflare_name
        }
        solvers = [{
          dns01 = {
            cloudflare = {
              email = var.letsencrypt_cloudflare_email
              apiTokenSecretRef = {
                name = "cloudflare-secret-token"
                key  = "cloudflare-token"
              }
            }
          }
          selector = {
            dnsZones = var.letsencrypt_cloudflare_dns_zones
          }
        }]
      }
    }
  }
}