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
  items = toset([for i in range(15) : tostring(i)])
}

resource "null_resource" "test_with_trigger" {
  for_each = local.items

  triggers = {
    always_run = timestamp()
    item       = each.key
  }

  provisioner "local-exec" {
    command = "echo Triggered resource ${each.key} at $(date)"
  }
}

resource "time_sleep" "wait_after_each_v2" {
  for_each = null_resource.test_with_trigger

  create_duration = "15s"

  depends_on = [
    null_resource.test_with_trigger
  ]
}
