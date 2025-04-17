<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_zstack"></a> [zstack](#requirement\_zstack) | 1.0.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_zstack"></a> [zstack](#provider\_zstack) | 1.0.8 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_spdk_image"></a> [spdk\_image](#module\_spdk\_image) | git::http://172.20.14.17/jiajian.chi/terraform-zstack-image.git | v1.1.1 |

## Resources

| Name | Type |
|------|------|
| [local_file.iscsi_config](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [terraform_data.remote_exec](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [zstack_instance.spdk_instance](https://registry.terraform.io/providers/ZStack-Robot/zstack/1.0.8/docs/resources/instance) | resource |
| [zstack_instance_offers.offers](https://registry.terraform.io/providers/ZStack-Robot/zstack/1.0.8/docs/data-sources/instance_offers) | data source |
| [zstack_l3networks.l3networks](https://registry.terraform.io/providers/ZStack-Robot/zstack/1.0.8/docs/data-sources/l3networks) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aio_disk"></a> [aio\_disk](#input\_aio\_disk) | Path to the AIO disk to use for iSCSI target | `string` | `"/dev/sda"` | no |
| <a name="input_backup_storage_name"></a> [backup\_storage\_name](#input\_backup\_storage\_name) | Name of the backup storage to use | `string` | `"bs"` | no |
| <a name="input_context"></a> [context](#input\_context) | Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.<br/><br/>Examples:<pre>context:<br/>  project:<br/>    name: string<br/>    id: string<br/>  environment:<br/>    name: string<br/>    id: string<br/>  resource:<br/>    name: string<br/>    id: string</pre> | `map(any)` | `{}` | no |
| <a name="input_data_disk_size"></a> [data\_disk\_size](#input\_data\_disk\_size) | data\_disk\_size for the iSCSI target | `number` | `100` | no |
| <a name="input_expunge"></a> [expunge](#input\_expunge) | Whether to expunge the resources when destroyed | `bool` | `true` | no |
| <a name="input_host_port"></a> [host\_port](#input\_host\_port) | Port for the iSCSI target | `number` | `3260` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Name for the SPDK image | `string` | `"spdk-by-terraform"` | no |
| <a name="input_image_url"></a> [image\_url](#input\_image\_url) | URL for the SPDK image | `string` | `"http://minio.zstack.io:9001/packer/spdk-by-packer-image-compressed.qcow2"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name for the SPDK instance | `string` | `"spdk-iscsi"` | no |
| <a name="input_instance_offering_name"></a> [instance\_offering\_name](#input\_instance\_offering\_name) | Name of the instance offering to use | `string` | `"8C-16G"` | no |
| <a name="input_instance_offering_uuid"></a> [instance\_offering\_uuid](#input\_instance\_offering\_uuid) | Uuid of the instance offering to use | `string` | n/a | yes |
| <a name="input_l3_network_name"></a> [l3\_network\_name](#input\_l3\_network\_name) | Name of the L3 network to use | `string` | `"test"` | no |
| <a name="input_netmask"></a> [netmask](#input\_netmask) | Netmask for the iSCSI target | `string` | `"172.30.0.0/16"` | no |
| <a name="input_node_base"></a> [node\_base](#input\_node\_base) | Base name for iSCSI target nodes | `string` | `"iqn.2016-06.io.spdk"` | no |
| <a name="input_ssh_password"></a> [ssh\_password](#input\_ssh\_password) | SSH password for connecting to the instance | `string` | `"ZStack@123"` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | SSH username for connecting to the instance | `string` | `"zstack"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iscsi_connection_string"></a> [iscsi\_connection\_string](#output\_iscsi\_connection\_string) | Connection string for the iSCSI target |
| <a name="output_iscsi_target_base"></a> [iscsi\_target\_base](#output\_iscsi\_target\_base) | Base name of the iSCSI target |
| <a name="output_iscsi_target_port"></a> [iscsi\_target\_port](#output\_iscsi\_target\_port) | Port of the iSCSI target |
| <a name="output_spdk_instance_ip"></a> [spdk\_instance\_ip](#output\_spdk\_instance\_ip) | IP address of the created SPDK instance |
| <a name="output_walrus_environment_id"></a> [walrus\_environment\_id](#output\_walrus\_environment\_id) | The id of environment where deployed in Walrus. |
| <a name="output_walrus_environment_name"></a> [walrus\_environment\_name](#output\_walrus\_environment\_name) | The name of environment where deployed in Walrus. |
| <a name="output_walrus_project_id"></a> [walrus\_project\_id](#output\_walrus\_project\_id) | The id of project where deployed in Walrus. |
| <a name="output_walrus_project_name"></a> [walrus\_project\_name](#output\_walrus\_project\_name) | The name of project where deployed in Walrus. |
| <a name="output_walrus_resource_id"></a> [walrus\_resource\_id](#output\_walrus\_resource\_id) | The id of resource where deployed in Walrus. |
| <a name="output_walrus_resource_name"></a> [walrus\_resource\_name](#output\_walrus\_resource\_name) | The name of resource where deployed in Walrus. |
<!-- END_TF_DOCS -->