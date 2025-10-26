terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.96"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  token     = var.yc_token
  zone      = "ru-central1-a"
}

# Используем существующую сеть "develop"
data "yandex_vpc_network" "develop" {
  name = "develop"
}

# Подсеть в этой сети
resource "yandex_vpc_subnet" "develop" {
  name           = "develop-subnet"
  zone           = "ru-central1-a"
  network_id     = data.yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}


# Группа безопасности
resource "yandex_vpc_security_group" "web-sg" {
  name        = "web-sg"
  description = "Security group for web servers"
  network_id  = data.yandex_vpc_network.develop.id

  ingress {
    protocol       = "TCP"
    port           = 22
    description    = "Allow SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    description    = "Allow HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
