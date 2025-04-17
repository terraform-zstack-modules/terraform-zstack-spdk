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

# 创建虚拟机实例
module "spdk_instance" {
  source = "git::http://172.20.14.17/jiajian.chi/terraform-zstack-instance.git?ref=v1.1.1"

  name                   = var.instance_name
  description            = "Created by Terraform devops"
  instance_count         = 1
  image_uuid             = module.spdk_image.image_uuid
  l3_network_name        = var.l3_network_name
  instance_offering_name = var.instance_offering_name
  expunge                = var.expunge

  data_disks = [
    {
      name           = "${var.instance_name}-data-disk-1"
      description    = "Data disk for SPDK storage"
      disk_size      = var.data_disk_size
    }
  ]
}

# 生成 iscsi_config 文件
resource "local_file" "iscsi_config" {
  content = templatefile("${path.module}/files/iscsi.json.tpl", {
    aio_disk  = var.aio_disk
    node_base = var.node_base
    host_ip   = module.spdk_instance.instance_ips[0]
    host_port = var.host_port
    netmask   = var.netmask
  })
  filename = "${path.module}/iscsi.json"
}


# 上传 iscsi_config  文件到实例
resource "terraform_data" "remote_exec" {
  depends_on = [module.spdk_instance, local_file.iscsi_config]

  connection {
    type     = "ssh"
    host     = module.spdk_instance.instance_ips[0]
    user     = var.ssh_user
    password = var.ssh_password
    timeout  = "5m"
  }

  provisioner "file" {
    source      = "${path.module}/iscsi.json"
    destination = "/root/iscsi.json"
    on_failure  = fail
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Starting iscsi tgt ...'",
      "nohup /root/spdk/build/bin/iscsi_tgt -c /root/iscsi.json > /var/log/iscsi_tgt.log 2>&1 &",
      "sleep 5",
      "ps aux | grep iscsi_tgt | grep -v grep || (echo 'Failed to start iscsi_tgt' && exit 1)",
      "echo 'iscsi_tgt started successfully'"
    ]
    on_failure = fail
  }

}