resource "kubernetes_manifest" "cloudflare_secret_token" {
  count = var.letsencrypt_cloudflare_enabled == true ? 1 : 0
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Secret"
    "metadata" = {
      "name"      = "cloudflare-secret-token"
      "namespace" = "${helm_release.certmanager[0].namespace}"
    }
    "type" = "Opaque"
    "stringData" = {
      "cloudflare-token" = "${var.letsencrypt_cloudflare_token}"
    }
  }

  depends_on = [helm_release.certmanager]
}

resource "kubernetes_manifest" "letsencrypt_cloudflare" {
  count = var.letsencrypt_cloudflare_enabled == true ? 1 : 0
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name"      = "letsencrypt-cloudflare"
      "namespace" = "${helm_release.certmanager[0].namespace}"
    }
    "spec" = {
      "acme" = {
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "email"  = "${var.letsencrypt_cloudflare_email}"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-cloudflare"
        }
        "solvers" = [{
          "dns01" = {
            "cloudflare" = {
              "email" = "${var.letsencrypt_cloudflare_email}"
              "apiTokenSecretRef" = {
                "name" = "cloudflare-secret-token"
                "key"  = "cloudflare-token"
              }
            }
          }
          "selector" = {
            "dnsZones" = ["${var.letsencrypt_cloudflare_domain_zone}"]
          }
        }]
      }
    }
  }

  depends_on = [helm_release.certmanager, kubernetes_manifest.cloudflare_secret_token]
}

resource "kubernetes_manifest" "letsencrypt_certificate_wildcard_dev" {
  count = var.letsencrypt_cloudflare_enabled == true ? 1 : 0
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "wildcard-dev-${var.letsencrypt_cloudflare_organization}-com"
      "namespace" = "${helm_release.istio_base[0].namespace}"
    }
    "spec" = {
      "secretName" = "wildcard-dev-${var.letsencrypt_cloudflare_organization}-com-tls"
      "privateKey" = {
        "algorithm" = "RSA"
        "encoding"  = "PKCS1"
        "size"      = 2048
      }
      "duration"    = "2160h" # 90 days
      "renewBefore" = "360h"  # 15 days
      "isCA"        = false
      "usages"      = ["server auth", "client auth"]
      "subject" = {
        "organizations" = ["${var.letsencrypt_cloudflare_organization}"]
      }
      "issuerRef" = {
        "name"  = "letsencrypt-cloudflare"
        "kind"  = "ClusterIssuer"
        "group" = "cert-manager.io"
      }
      "dnsNames" = ["*.dev.${var.letsencrypt_cloudflare_domain_zone}"]
    }
  }

  depends_on = [
    helm_release.certmanager,
    kubernetes_manifest.letsencrypt_cloudflare,
    helm_release.istio_base
  ]
}