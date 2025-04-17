terraform {
  required_version = ">= 1.0"

  required_providers {
    zstack = {
      source  = "ZStack-Robot/zstack"
      version = "1.0.8"
    }
  }
}