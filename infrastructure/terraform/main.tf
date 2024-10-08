terraform {
  
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  
  required_version = ">= 0.13"
  
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gq6i9mlg31t04r5ddr/etn9fk4v44104so88pff"
    }
    region = "ru-central1"
    bucket = "terraform-s3-027-04"
    skip_region_validation = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # This option is required for Terraform 1.6.1 or higher.
    skip_s3_checksum            = true # This option is required to describe backend for Terraform version 1.6.3 or higher.
    key = "terraform/terraform.tfstate"
    access_key = "YCAJEua7TjpGxSoNnsGk_TgBG"
  }

}

provider "yandex" {
   zone = var.zone
   cloud_id = var.cloud_id
   folder_id = var.folder_id
   token = var.iam_token
}

resource "yandex_kubernetes_cluster" "k8s_zonal_cluster" {
 network_id = yandex_vpc_network.k8s-network.id
 master {
   version = var.k8s_version
   zonal {
     zone      = yandex_vpc_subnet.k8s-subnet.zone
     subnet_id = yandex_vpc_subnet.k8s-subnet.id
   }
   public_ip = true
 }
 service_account_id      = yandex_iam_service_account.kubernetes.id
 node_service_account_id = yandex_iam_service_account.kubernetes.id
   depends_on = [
     yandex_resourcemanager_folder_iam_binding.editor,
     yandex_resourcemanager_folder_iam_binding.images-puller
   ]
}

resource "yandex_vpc_network" "k8s-network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s-subnet" {
 name = "k8s-subnet"
 v4_cidr_blocks = [var.v4_cidr_blocks]
 zone           = var.zone
 network_id     = yandex_vpc_network.k8s-network.id
}

resource "yandex_iam_service_account" "kubernetes" {
 name        = "kubernetes"
 description = "Service account for manage kubernetes"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 # Сервисному аккаунту назначается роль "editor".
 folder_id = var.folder_id
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.kubernetes.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
 folder_id = var.folder_id
 role      = "container-registry.images.puller"
 members   = [
   "serviceAccount:${yandex_iam_service_account.kubernetes.id}"
 ]
}

resource "yandex_kubernetes_node_group" "k8s-node-group" {
  cluster_id  = "${yandex_kubernetes_cluster.k8s_zonal_cluster.id}"
  name        = "k8s-node-group"
  version     = var.k8s_version

  instance_template {
    platform_id = var.platform_id

    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.k8s-subnet.id}"]
    }

    resources {
      memory = var.node_memory
      cores  = var.node_cores
      core_fraction = var.node_core_fraction
    }

    boot_disk {
      type = var.boot_disk_type
      size = var.boot_disk_size
    }
  }

  scale_policy {
    fixed_scale {
      size = var.nodes_count
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

}
