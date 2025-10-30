variable "cloud_id" {
  type        = string
  default     = "b1gsbe1c3k6ciume68nq"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1g1uoqkuj21b8pkvi3d"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

### Vars for Ex.2

variable "counter_vm" {
  type        = number
  default     = 2
  description = "How many VM"
}

variable "web_cores" {
  type        = number
  default     = "2"
  description = "Number of cores"
}

variable "web_memory" {
  type        = number
  default     = "1"
  description = "Amount of memory"
}



variable "preempt_on" {
  type        = bool
  default     = true
  description = "Preemptible is always on"
}
variable "nat_is_on" {
  type        = bool
  default     = true
  description = "NAT"
}

### Vars for Ex.3

variable "each_vm" {
  type          = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number }))
  default = [
    {         vm_name    = "main"
              cpu         = 2
              ram         = 2
              disk_volume = 10
    },
    {         vm_name     = "replica"
              cpu         = 2
              ram         = 1
              disk_volume = 5
    }]
}
### Vars for Ex.4

variable "vdisks" {
  type = object({
    name = string
    counter = number
    type = string
    size = number
  })

  default = {
    name = "vdisk"
    counter = 3
    type = "network-hdd"
    size = 1
  }
  description = "Info about disks"
}

variable "storage_vm" {
  type = object({
    name = string
    hostname = string
    cores = number
    memory = number
    core_fraction = number
  })
  default = {
    name = "storage"
    hostname = "storage"
    cores = 2
    memory = 1
    core_fraction = 20
  }
}

### Common vars

variable "common_core_fraction" {
  type        = number
  default     = "20"
  description = "Common core fraction"
}

variable "family_name" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Type of the OS"
}

variable "common_platform" {
  type        = string
  default     = "standard-v1"
  description = "Common platform"
}

variable "common_metadata" {
  description = "Meta data for SSH"
  type        = map(string)
  default     = {
    serial-port-enable = "1"
    #ssh-keys           = "ubuntu:${file("~/.ssh/id_eded25519.pub")}"
  }
}
