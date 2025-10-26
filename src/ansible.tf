# Создаём inventory-файл для Ansible
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"

  content = templatefile("${path.module}/templates/inventory.tmpl", {
    webservers = [
      for vm in yandex_compute_instance.web : {
        name        = vm.name
        external_ip = vm.network_interface[0].nat_ip_address
        fqdn        = vm.fqdn
      }
    ]
    databases = [
      for vm in yandex_compute_instance.db : {
        name        = vm.name
        external_ip = vm.network_interface[0].nat_ip_address
        fqdn        = vm.fqdn
      }
    ]
    storage = [
      for vm in yandex_compute_instance.storage : {
        name        = vm.name
        external_ip = vm.network_interface[0].nat_ip_address
        fqdn        = vm.fqdn
      }
    ]
  })
}
