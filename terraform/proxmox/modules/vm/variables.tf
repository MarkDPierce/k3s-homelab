variable "vm_name" {
  type = string
}

variable "target_node" {
  type = string
}

variable "desc" {
  type    = string
  default = "TERRAFORM MANAGED!!!"
}

variable "bios" {
  type    = string
  default = "seabios"
}

variable "iso" {
  type    = string
  default = "ISO:iso/debian-12.5.0-amd64-DVD-1.iso"
}

variable "os_version" {
  type    = string
  default = "l26"
}

variable "memory" {
  type    = number
  default = 1024
}

variable "sockets" {
  type    = number
  default = 1
}

variable "cores" {
  type    = number
  default = 2
}

variable "tags" {
  type    = string
  default = "terraform, kubernetes"
}

variable "os_type" {
  type    = string
  default = "Linux 5.x - 2.6 Kernel"
}

variable "disk_size" {
  type    = number
  default = 32
}

variable "disk_location" {
  type    = string
  default = "local-lvm"
}
