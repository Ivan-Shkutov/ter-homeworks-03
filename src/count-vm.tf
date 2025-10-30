data "yandex_compute_image" "ubuntu" {
  family            = var.family_name
}

resource "yandex_compute_instance" "web" {
  depends_on = [yandex_compute_instance.main_replica]

  count             = var.counter_vm
  name              = "web-${ count.index + 1}"
  hostname          = "${ yandex_vpc_network.develop.name }-web-${ count.index + 1 }"
  platform_id       = var.common_platform
  zone              = var.default_zone

  resources {
    cores           = var.web_cores
    memory          = var.web_memory
    core_fraction   = var.common_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id     = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible    = var.preempt_on
  }

  network_interface {

    subnet_id      = yandex_vpc_subnet.develop.id
    nat            = var.nat_is_on
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  metadata = merge(var.common_metadata, local.metadata)

}
