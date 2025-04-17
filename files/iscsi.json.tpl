{
  "subsystems": [
    {
      "subsystem": "scheduler",
      "config": [
        {
          "method": "framework_set_scheduler",
          "params": {
            "name": "static"
          }
        }
      ]
    },
    {
      "subsystem": "sock",
      "config": [
        {
          "method": "sock_set_default_impl",
          "params": {
            "impl_name": "posix"
          }
        },
        {
          "method": "sock_impl_set_options",
          "params": {
            "impl_name": "posix",
            "recv_buf_size": 2097152,
            "send_buf_size": 2097152,
            "enable_recv_pipe": true,
            "enable_quickack": false,
            "enable_placement_id": 0,
            "enable_zerocopy_send_server": true,
            "enable_zerocopy_send_client": false,
            "zerocopy_threshold": 0,
            "tls_version": 0,
            "enable_ktls": false
          }
        }
      ]
    },
    {
      "subsystem": "iobuf",
      "config": [
        {
          "method": "iobuf_set_options",
          "params": {
            "small_pool_count": 8192,
            "large_pool_count": 1024,
            "small_bufsize": 8192,
            "large_bufsize": 135168
          }
        }
      ]
    },
    {
      "subsystem": "bdev",
      "config": [
        {
          "method": "bdev_set_options",
          "params": {
            "bdev_io_pool_size": 65535,
            "bdev_io_cache_size": 256,
            "bdev_auto_examine": true,
            "iobuf_small_cache_size": 128,
            "iobuf_large_cache_size": 16
          }
        },
        {
          "method": "bdev_aio_create",
          "params": {
            "name": "AIO_Disk",
            "filename": "${aio_disk}",
            "block_size": 512
          }
        },
        {
          "method": "bdev_wait_for_examine"
        }
      ]
    },
    {
      "subsystem": "scsi",
      "config": null
    },
    {
      "subsystem": "iscsi",
      "config": [
        {
          "method": "iscsi_set_options",
          "params": {
            "node_base": "${node_base}",
            "max_sessions": 128,
            "max_connections_per_session": 2,
            "max_queue_depth": 64,
            "default_time2wait": 2,
            "default_time2retain": 20,
            "first_burst_length": 8192,
            "immediate_data": true,
            "allow_duplicated_isid": false,
            "error_recovery_level": 0,
            "nop_timeout": 60,
            "nop_in_interval": 30,
            "disable_chap": false,
            "require_chap": false,
            "mutual_chap": false,
            "chap_group": 0,
            "max_large_datain_per_connection": 64,
            "max_r2t_per_connection": 4,
            "pdu_pool_size": 36864,
            "immediate_data_pool_size": 16384,
            "data_out_pool_size": 2048
          }
        },
        {
          "method": "iscsi_create_portal_group",
          "params": {
            "tag": 1,
            "portals": [
              {
                "host": "${host_ip}",
                "port": "${host_port}"
              }
            ],
            "private": false
          }
        },
        {
          "method": "iscsi_create_initiator_group",
          "params": {
            "tag": 2,
            "initiators": [
              "ANY"
            ],
            "netmasks": [
              "${netmask}"
            ]
          }
        },
        {
          "method": "iscsi_create_target_node",
          "params": {
            "name": "${node_base}:disk1",
            "alias_name": "Physical Disk SDB",
            "pg_ig_maps": [
              {
                "pg_tag": 1,
                "ig_tag": 2
              }
            ],
            "luns": [
              {
                "bdev_name": "AIO_Disk",
                "lun_id": 0
              }
            ],
            "queue_depth": 64,
            "disable_chap": true,
            "require_chap": false,
            "mutual_chap": false,
            "chap_group": 0,
            "header_digest": false,
            "data_digest": false
          }
        }
      ]
    }
  ]
}