#
# Contextual output
#

output "walrus_project_name" {
  value       = try(local.context["project"]["name"], null)
  description = "The name of project where deployed in Walrus."
}

output "walrus_project_id" {
  value       = try(local.context["project"]["id"], null)
  description = "The id of project where deployed in Walrus."
}

output "walrus_environment_name" {
  value       = try(local.context["environment"]["name"], null)
  description = "The name of environment where deployed in Walrus."
}

output "walrus_environment_id" {
  value       = try(local.context["environment"]["id"], null)
  description = "The id of environment where deployed in Walrus."
}

output "walrus_resource_name" {
  value       = try(local.context["resource"]["name"], null)
  description = "The name of resource where deployed in Walrus."
}

output "walrus_resource_id" {
  value       = try(local.context["resource"]["id"], null)
  description = "The id of resource where deployed in Walrus."
}


output "spdk_instance_ip" {
  description = "IP address of the created SPDK instance"
  value       = module.spdk_instance.instance_ips[0]
}


output "iscsi_target_base" {
  description = "Base name of the iSCSI target"
  value       = var.node_base
}

output "iscsi_target_port" {
  description = "Port of the iSCSI target"
  value       = var.host_port
}

output "iscsi_connection_string" {
  description = "Connection string for the iSCSI target"
  value       = "${var.node_base}:target1 @ ${module.spdk_instance.instance_ips[0]}:${var.host_port}"
}
