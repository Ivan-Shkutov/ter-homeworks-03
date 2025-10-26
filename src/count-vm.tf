locals {
  ssh_key = file("~/.ssh/id_rsa.pub")
}

resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}" # web-1 и web-2
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi" # Ubuntu 22.04 LTS — можно уточнить ID командой yc compute image list
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web-sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_key}"
  }

  depends_on = [yandex_compute_instance.db]
}
