# Создаём inventory-файл для Ansible
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/all_hosts.tftpl",

    {
    webservers = yandex_compute_instance.web
    databases  = yandex_compute_instance.main_replica
    storage    = [yandex_compute_instance.storage]

  })
  filename = "${abspath(path.module)}/all_hosts.cfg"
}
