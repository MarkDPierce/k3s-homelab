/*
 I know I can further clean this up. For now I want to leave the nodes as is for future projects. It will be nice to tweak them.
 My development k3s stack.
  Consists of a server with min specs and then 5 agents.
  OS is debian 12
*/

locals {
  vms = [
    {
      vm_name     = "k3s-dev-server01"
      target_node = var.target_node
      memory      = var.server_memory
      cores       = 2
      disk_size   = var.disk_size
    },
    {
      vm_name     = "${var.node_name}01"
      target_node = var.target_node
      memory      = var.node_memory
      cores       = var.cores
      disk_size   = var.disk_size
    },
  ]
  # In the event I want to simulate my Raspberry Pi Cluster
  rpi = [
    {
      vm_name     = "k3s-pi-server01"
      target_node = var.target_node
      memory      = 2048
      cores       = 2
      disk_size   = 50
    },
    {
      vm_name     = "k3s-pi-node01"
      target_node = var.target_node
      memory      = 2048
      cores       = 2
      disk_size   = 50
    },
    {
      vm_name     = "k3s-pi-node02"
      target_node = var.target_node
      memory      = 2048
      cores       = 2
      disk_size   = 50
    },
    {
      vm_name     = "k3s-pi-node03"
      target_node = var.target_node
      memory      = 2048
      cores       = 2
      disk_size   = 50
    }
  ]
}

# One Loop to rule them all
# K3S Cluster
module "k3s-cluster" {
  source = "./modules/vm"

  for_each = { for vm in local.vms : vm.vm_name => vm }

  vm_name     = each.value.vm_name
  target_node = each.value.target_node
  memory      = each.value.memory
  cores       = each.value.cores
  disk_size   = each.value.disk_size
}

/* OH NOES!!! UNUSED CODE!!!
module "rpi-cluster" {
  source = "./modules/vm"

  for_each = { for vm in local.rpi : vm.vm_name => vm }

  vm_name     = each.value.vm_name
  target_node = each.value.target_node
  memory      = each.value.memory
  cores       = each.value.cores
  disk_size   = each.value.disk_size
}
*/
