terraform {
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

provider "time" {}

locals {
  items = toset([for i in range(5) : tostring(i)])
}

resource "null_resource" "test" {
  for_each = local.items

  provisioner "local-exec" {
    command = "echo Creating resource ${each.key}"
  }
}

resource "time_sleep" "wait_after_each" {
  for_each = null_resource.test

  create_duration = "15s"
}
