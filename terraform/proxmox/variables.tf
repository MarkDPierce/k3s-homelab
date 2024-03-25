variable "target_node" {
  default     = "proxmox02"
  description = "The Proxmox server (node) you are deploying to."
}

variable "server_memory" {
  default     = 2048
  description = "Cluster server memory"
}

variable "node_memory" {
  default     = 12288
  description = "Cluster node memory"
}

variable "cores" {
  default = 6
}

variable "disk_size" {
  default     = 32
  description = "Base disk size in GB."
}

variable "node_name" {
  default     = "k3s-dev-node"
  description = "Just helps with sanity and consistency."
}
