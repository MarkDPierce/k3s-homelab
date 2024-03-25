terraform {
  required_providers {
    proxmox = {
      # Docs: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
    sops = {
      # Docs: https://registry.terraform.io/providers/carlpett/sops/latest/docs
      source  = "carlpett/sops"
      version = "1.0.0"
    }
  }
}

data "sops_file" "secrets" {
  source_file = "../secrets.yaml"
  input_type  = "yaml"
}

provider "proxmox" {
  pm_api_url  = "${data.sops_file.secrets.data["endpoint"]}api2/json"
  pm_user     = data.sops_file.secrets.data["username"]
  pm_password = data.sops_file.secrets.data["password"]
}
