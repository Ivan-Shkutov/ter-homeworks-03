# ---------- Создаём 3 диска ----------
resource "yandex_compute_disk" "data_disk" {
  count = 3
  name  = "data-disk-${count.index + 1}"
  size  = 1 # размер в ГБ
  type  = "network-hdd"
  zone  = "ru-central1-a"
}

# ---------- Создаём ВМ ----------
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi" # пример — Ubuntu 20.04 (замени на актуальный image_id)
    }
  }

  network_interface {
    subnet_id = "e9bdsg6v44ldrf2hu8ug" # замени на свой subnet_id
    nat       = true
  }

  # ---------- Подключаем дополнительные диски ----------
  dynamic "secondary_disk" {
    for_each = { for d in yandex_compute_disk.data_disk : d.name => d }
    content {
      disk_id = secondary_disk.value.id
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
# ---------- Выводим внешний IP-адрес ----------
output "storage_external_ip" {
  description = "Внешний IP-адрес ВМ storage"
  value       = yandex_compute_instance.storage.network_interface[0].nat_ip_address
}