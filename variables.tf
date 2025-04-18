#
# Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}

variable "image_name" {
  description = "Name for the SPDK image"
  type        = string
  default     = "spdk-by-terraform"
}

variable "image_url" {
  description = "URL for the SPDK image"
  type        = string
  default     = "http://minio.zstack.io:9001/packer/spdk-by-packer-image-compressed.qcow2"
}

variable "expunge" {
  description = "Whether to expunge the resources when destroyed"
  type        = bool
  default     = true
}

variable "backup_storage_name" {
  description = "Name of the backup storage to use"
  type        = string
  default     = "bs"
}

variable "instance_name" {
  description = "Name for the SPDK instance"
  type        = string
  default     = "spdk-iscsi"
}

variable "l3_network_name" {
  description = "Name of the L3 network to use"
  type        = string
  default     = "test"
}

variable "instance_offering_name" {
  description = "Name of the instance offering to use"
  type        = string
  default     = "8C-16G"
}

variable "instance_offering_uuid" {
  description = "Uuid of the instance offering to use"
  type        = string
}

variable "never_stop" {
  type        = bool
  default     = true
}

variable "l3_network_uuids" {
  type        = list(string)
  description = "UUIDs of L3 networks (used if l3_network_name is not provided)"
  default     = []
}


variable "aio_disk" {
  description = "Path to the AIO disk to use for iSCSI target"
  type        = string
  default     = "/dev/vda"
}

variable "node_base" {
  description = "Base name for iSCSI target nodes"
  type        = string
  default     = "iqn.2016-06.io.spdk"
}

variable "host_port" {
  description = "Port for the iSCSI target"
  type        = number
  default     = 3260
}

variable "netmask" {
  description = "Netmask for the iSCSI target"
  type        = string
  default     = "172.30.0.0/16"
}

variable "data_disk_size" {
  description = "data_disk_size for the iSCSI target"
  type        = number
  default     = 100
}

variable "virtio_scsi" {
  description = "data_disk virtio enabled"
  type        = bool
  default     = false
}

variable "ssh_user" {
  description = "SSH username for connecting to the instance"
  type        = string
  default     = "zstack"
}

variable "ssh_password" {
  description = "SSH password for connecting to the instance"
  type        = string
  sensitive   = true
  default     = "ZStack@123"
}
