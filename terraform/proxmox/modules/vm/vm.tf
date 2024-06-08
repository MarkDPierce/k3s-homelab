resource "proxmox_vm_qemu" "pxe" {
  name        = var.vm_name
  target_node = var.target_node
  desc        = var.desc
  bios        = var.bios
  # startup     = ""
  onboot                 = true
  vm_state               = "stopped"
  define_connection_info = true
  boot                   = "order=ide2;scsi0"
  agent                  = 1
  iso                    = var.iso
  qemu_os                = var.os_version
  memory                 = var.memory
  balloon                = 0
  sockets                = var.sockets
  cores                  = var.cores
  cpu                    = "host"
  scsihw                 = "virtio-scsi-pci"
  tags                   = var.tags
  os_type                = var.os_type

  lifecycle {
    #prevent_destroy = true
    ignore_changes = [
      vm_state,
      tags,
    ]
  }

  vga {
    type   = "std"
    memory = 215
  }

  network {
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "virtio"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          backup             = true
          cache              = "none"
          discard            = true
          emulatessd         = true
          iothread           = true
          mbps_r_burst       = 0.0
          mbps_r_concurrent  = 0.0
          mbps_wr_burst      = 0.0
          mbps_wr_concurrent = 0.0
          replicate          = true
          size               = var.disk_size
          storage            = var.disk_location
        }
      }
    }
  }
}
