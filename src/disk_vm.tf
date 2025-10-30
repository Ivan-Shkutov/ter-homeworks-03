#  Создаём 3 виртуальных диска

resource "yandex_compute_disk" "disks" {
  zone = var.default_zone
  count = var.vdisks.counter
  name = "${ var.vdisks.name }-${ count.index + 1 }"
  type = var.vdisks.type
  size = var.vdisks.size
}

#  Создаём ВМ

resource "yandex_compute_instance" "storage" {
  name              = var.storage_vm.name
  hostname          = var.storage_vm.hostname
  platform_id       = var.common_platform
  zone              = var.default_zone
  resources {
    cores           = var.storage_vm.cores
    memory          = var.storage_vm.memory
    core_fraction   = var.storage_vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id     = data.yandex_compute_image.ubuntu.image_id
    }
  }

  #  Подключаем дополнительные диски

 dynamic "secondary_disk" {
    for_each = yandex_compute_disk.virtual_disks.*.id
    content {
      disk_id = secondary_disk.value
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
