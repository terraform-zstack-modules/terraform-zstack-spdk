locals {
  context = var.context
}

module "spdk_image" {
  source = "git::http://172.20.14.17/jiajian.chi/terraform-zstack-image.git?ref=v1.1.1"

  create_image  = true
  image_name    = var.image_name
  image_url     = var.image_url
  guest_os_type = "Ubuntu20.04"
  platform      = "Linux"
  format        = "qcow2"
  architecture  = "x86_64"
  expunge       = var.expunge

  backup_storage_name = var.backup_storage_name
}

data "zstack_l3networks" "l3networks" {
  count = var.l3_network_name != null ? 1 : 0
  name  = var.l3_network_name
}

data "zstack_instance_offers" "offers" {
  count = var.instance_offering_name != null ? 1 : 0
  name  = var.instance_offering_name
}

locals {
  l3_network_uuids = var.l3_network_name != "" ? [data.zstack_l3networks.l3networks[0].l3networks[0].uuid] : var.l3_network_uuids

  instance_offering_uuid = var.instance_offering_uuid != "" ? var.instance_offering_uuid : (
    try(data.zstack_instance_offers.offers[0].instance_offers[0].uuid, "")
  )
}


# 创建虚拟机实例
resource "zstack_instance" "spdk_instance" {
  name                   = var.instance_name
  description            = "Created by Terraform devops"
  instance_offering_uuid = local.instance_offering_uuid != "" ? local.instance_offering_uuid : null
  l3_network_uuids       = local.l3_network_uuids
  never_stop             = var.never_stop

  image_uuid             = module.spdk_image.image_uuid
  expunge                = var.expunge

  data_disks = [
    {
      name           = "${var.instance_name}-data-disk-1"
      description    = "Data disk for SPDK storage"
      size           = var.data_disk_size
      virtio_scsi    = var.virtio_scsi
    }
  ]
}

# 生成 iscsi_config 文件
resource "local_file" "iscsi_config" {
  content = templatefile("${path.module}/files/iscsi.json.tpl", {
    aio_disk  = var.aio_disk
    node_base = var.node_base
    host_ip   = zstack_instance.spdk_instance.vm_nics[0].ip
    host_port = var.host_port
    netmask   = var.netmask
  })
  filename = "${path.module}/iscsi.json"
}


# 上传 iscsi_config  文件到实例
resource "terraform_data" "remote_exec" {
  depends_on = [zstack_instance.spdk_instance, local_file.iscsi_config]

  connection {
    type     = "ssh"
    host     = zstack_instance.spdk_instance.vm_nics[0].ip
    user     = var.ssh_user
    password = var.ssh_password
    timeout  = "5m"
  }

  provisioner "file" {
    source      = "${path.module}/iscsi.json"
    destination = "/tmp/iscsi.json"
    on_failure  = fail
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/iscsi.json /root/iscsi.json",
      "echo 'Starting iscsi tgt ...'",
      "sudo nohup /root/spdk/build/bin/iscsi_tgt -c /root/iscsi.json > /tmp/iscsi_tgt.log 2>&1 &",
      "sudo sleep 5",
      "sudo ps aux | grep iscsi_tgt | grep -v grep || (echo 'Failed to start iscsi_tgt' && exit 1)",
      "echo 'iscsi_tgt started successfully'"
    ]
    on_failure = fail
  }

}