# proxmox variables
variable "pm_api_url" {
  description = "proxmox api url"
  type        = string
}
variable "pm_api_token_secret" {
  sensitive   = true
  description = "proxmox api token secret"
  type        = string
}
variable "pm_api_token_id" {
  description = "proxmox api token id"
  type        = string
}
variable "vm_template_name" {
  description = "proxmox VM template name"
  type        = string
}
variable "pm_target_node" {
  description = "proxmox target node"
  type        = string
}
variable "vm_tags" {
  type    = string
  default = "proxmox-vm"
}

# VM variables
variable "node_count" {
  description = "Number of virtual servers to create"
  type        = number
}
variable "cluster_name" {
  description = "VM prefix name"
  type        = string
  default     = "cluster"
}
variable "vm_onboot" {
  type        = bool
  description = "Start the VM right after Proxmox host starts"
  default     = true
}
variable "vm_bootdisk" {
  description = "vm boot disk"
  type        = string
  default     = "virtio0"
}

# User
variable "vm_user" {
  description = "VM user"
  type        = string
}
variable "vm_user_password" {
  description = "vm_user passwork"
  type        = string
  sensitive   = true
}
variable "ssh_key" {
  description = "vm_user sshkey"
  sensitive   = true
  type        = string
}
variable "ssh_key_location" {
  sensitive   = true
  description = "ssh location"
  type        = string
}

# RAM CPU
variable "vm_memory" {
  description = "VM Ram in MB"
  type        = number
  default     = 4096
}
variable "vm_cpu_type" {
  description = "The type of CPU to emulate in the Guest"
  type        = string
  default     = "host"
}
variable "vm_vcpu" {
  description = "the number of CPU cores to allocate to the VM"
  type        = number
  default     = 2
}

# Network

# vm_host_number is a whole number that can be represented as a binary integer 
# with no more than the number of digits remaining in the address after the given prefix. 
# If hostnum is negative, the count starts from the end of the range. 
# For example, cidrhost("10.0.0.0/8", 2) returns 10.0.0.2 and cidrhost("10.0.0.0/8", -2) returns 10.255.255.254.
# ex: 
# cird: 192.168.1.0/24
# vm_host_number = 150
# ip range 192.168.150, 192.168.151, 192.168.152
variable "vm_host_number" {
  type        = number
  description = "The host number of the VM in the subnet"
}
variable "vm_network_cidr" {
  description = "netwrok cidr"
  type        = string

}

# Disk
variable "vm_os_disk_size" {
  description = "VM os disk size"
  type        = number
}
variable "vm_os_disk_location" {
  description = "Disk storeage location on proxmox"
  type        = string
  default     = "local-lvm"
}

variable "vm_data_disk_size" {
  description = "VM data disk size"
  type        = number
}
variable "vm_data_disk_location" {
  description = "Disk storeage location on proxmox"
  type        = string
  default     = "local-lvm"
}

#
variable "use_legacy_naming_convention" {
  description = "Version <= 3.x, set it to `true`"
  type    = bool
  default = false
}

# local variable
# g
locals {
  # get vm net subnet mask ex: 192.168.0.1/24 > /24
  vm_net_subnet_mask = "/${split("/", var.vm_network_cidr)[1]}"
  # get default gateway from cird: > 192.168.1.1
  vm_net_default_gw  = cidrhost(var.vm_network_cidr, 1)
}
