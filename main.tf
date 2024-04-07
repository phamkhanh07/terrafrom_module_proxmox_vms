resource "proxmox_vm_qemu" "vm" {
  count                   = var.node_count
  desc                    = "vm on proxmox"
  name                    = "${var.cluster_name}-instance-${format("%02d", count.index)}"
  onboot                  = true
  scsihw                  = "virtio-scsi-pci"
  bootdisk                = "virtio0"
  boot                    = "order=virtio0"
  qemu_os                 = "l26"
  os_type                 = "ubuntu"
  agent                   = 1
  cloudinit_cdrom_storage = "local-lvm"
  define_connection_info  = true
  target_node             = var.pm_target_node
  clone                   = var.vm_template_name
  full_clone              = true

  ssh_user   = var.vm_user
  sshkeys    = var.ssh_key
  ciuser     = var.vm_user
  cipassword = var.vm_user_password

  memory = var.vm_memory
  cores  = var.vm_vcpu
  cpu    = var.vm_cpu_type

  disks {
    virtio {
      virtio0 {
        disk {
          size    = var.vm_os_disk_size
          storage = var.vm_os_disk_location
        }
      }
      virtio1 {
        disk {
          size    = var.vm_data_disk_size
          storage = var.vm_data_disk_location
        }
      }
    }
  }
  network {
    bridge   = "vmbr0"
    firewall = false
    model    = "virtio"
  }
  ipconfig0 = "ip=${cidrhost(var.vm_network_cidr, var.vm_host_number + count.index)}${local.vm_net_subnet_mask},gw=${local.vm_net_default_gw}"
  lifecycle {
    ignore_changes = [tags]
  }
}
