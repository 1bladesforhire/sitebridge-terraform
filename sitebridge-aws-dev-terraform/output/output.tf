########################################################################
# Output information about sitebridge clusters in S3
########################################################################
variable "output_bucket" {
  default = "sitebridge-tf-clusters"
}

variable "cluster_info" {
  type = "map"
}

variable "region" {}

variable "hosts_info" {
  type = "map"
}

variable "provider" {
  default = "aws"
}

locals {
  create_s3 = "${var.cluster_info["numInstances"] == 0 ? 0 : 1}"
}

resource "aws_s3_bucket_object" "cluster_info" {
  count        = "${local.create_s3}"
  bucket       = "${var.output_bucket}"
  key          = "sitebridge/${var.cluster_info["sitebridge"]}/cluster.json"
  content      = "${jsonencode(var.cluster_info)}"
  content_type = "text/json"
}

resource "aws_s3_bucket_object" "hosts_info" {
  count        = "${local.create_s3}"
  bucket       = "${var.output_bucket}"
  key          = "sitebridge/${var.cluster_info["sitebridge"]}/hosts.json"
  content      = "${data.template_file.hosts.rendered}"
  content_type = "text/json"
}

data "template_file" "host" {
  template = "${file("output/host.tpl.json")}"
  count    = "${var.cluster_info["numInstances"]}"

  vars {
    name           = "${element(var.hosts_info["hostnames"], count.index)}"
    publicip       = "${element(var.hosts_info["public_ips"], count.index)}"
    ip             = "${element(var.hosts_info["private_ips"], count.index)}"
    instanceId     = "${element(var.hosts_info["instance_ids"], count.index)}"
    sitebridgeName = "${var.cluster_info["sitebridge"]}"
    provider       = "${var.provider}"
    region         = "${var.region}"
  }
}

data "template_file" "hosts" {
  template = "${file("output/hosts.tpl.json")}"

  vars {
    hosts = "${join(",", data.template_file.host.*.rendered)}"
  }
}
