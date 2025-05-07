terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "3.61.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

provider "datadog" {
  app_key = var.datadog_app_key
  api_key = var.datadog_api_key
  api_url = "https://api.datadoghq.eu/"
}


resource "helm_release" "datadog" {
  name       = "datadog-agent"
  chart      = "datadog"
  repository = "https://helm.datadoghq.com"
  version    = "3.10.9"

  values = [
    yamlencode({
      targetSystem = "linux"
      datadog = {
        apiKey = var.datadog_api_key
        site   = var.datadog_site
        clusterAgent = {
          enabled = true
        }
        logs = {
          enabled             = true
          containerCollectAll = true
        }
        serviceMonitoring = {
          enabled = true
        }
        kubelet = {
          tlsVerify = false
        }
        processAgent = {
          enabled           = true
          processCollection = true
        }
        orchestratorExplorer = {
          enabled = true
        }
        eventCollection = {
          collectKubernetesEvents = true
        }
      }
    })
  ]
}

resource "helm_release" "test-http-app" {
  name  = "test-http-app"
  chart = "../helm/test-http-app"
}


resource "datadog_monitor" "imagepullbackoff" {
  name               = "ERROR: ImagePullBackOff"
  type               = "event-v2 alert"
  message            = "ImagePullBackOff detected."

  query        = <<-EOT
   events("source:kubernetes kubernetes_kind:pod status:warn \"ImagePullBackOff\"")
   .rollup("count")
   .by("pod_name")
   .last("5m") >= 1
EOT
  include_tags = true

  monitor_thresholds {
    critical = 1
  }
}

