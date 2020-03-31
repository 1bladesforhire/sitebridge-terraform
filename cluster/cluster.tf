########################################################################
# Variables Definitions
########################################################################
variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "subnet_id" {
  type        = "string"
  description = "subnet id to create the instance in"
}

variable "resourceName" {
  type        = "string"
  description = "Name to be used on a resource as cluster name as prefix"
}

variable "numInstances" {}

variable "natpool_cidr_block" {
  type = "string"
}

variable "igw_id" {
  type = "string"
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = "list"
}

variable "kingdom" {
  default = ""
}

variable "platformName" {
  default = ""
}

variable "sitebridge" {}

variable "sitebridgeImage" {}

variable "amiList" {
  type = "list"
}

variable "externalIPs" {
  type = "list"
}

variable "instanceNamePrefix" {}

variable "instanceNameSuffix" {}

variable "instance_type" {
  default = "c4.xlarge"
}

variable "instanceTypeList" {
  type = "list"
}

variable "cloudInitFolder" {
  type = "list"

  default = [
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
    "current",
  ]
}

########################################################################
# Create Sitebridge VPC/Subnet Control Path Hosts
########################################################################
locals {
  sitebridgeNameList                   = ["${var.sitebridge}"]
  is_external_ip_length_correct        = "${(length(var.externalIPs) == 0 || var.numInstances == length(var.externalIPs)) == true ? 0 : 1}"
  is_ami_list_length_correct           = "${(length(var.amiList) == 0 || var.numInstances == length(var.amiList)) == true ? 0 : 1}"
  is_instance_type_list_length_correct = "${(length(var.instanceTypeList) == 0 || var.numInstances == length(var.instanceTypeList)) == true ? 0 : 1}"
}

resource "null_resource" "is_external_ip_length_check" {
  count                                                                                 = "${local.is_external_ip_length_correct}"
  "ERROR: The var.externalIPs if specified should match the number of var.numInstances" = true
}

resource "null_resource" "is_ami_list_length_check" {
  count                                                                                       = "${local.is_ami_list_length_correct}"
  "ERROR: The length of var.amiList if specified should match the number of var.numInstances" = true
}

resource "null_resource" "is_instance_type_list_length_check" {
  count                                                                                                = "${local.is_instance_type_list_length_correct}"
  "ERROR: The length of var.instanceTypeList if specified should match the number of var.numInstances" = true
}

module "sitebridgeNode" {
  source = "hosts/sitebridgeNode"

  numInstances           = "${var.numInstances}"
  name                   = "${var.resourceName}"
  amiList                = "${var.amiList}"
  instanceTypeList       = "${var.instanceTypeList}"
  externalIPs            = "${var.externalIPs}"
  instanceNamePrefix     = "${var.instanceNamePrefix}"
  instanceNameSuffix     = "${var.instanceNameSuffix}"
  sitebridgeImage        = "${var.sitebridgeImage}"
  kingdomName            = "${var.kingdom}"
  platformName           = "${var.platformName}"
  sitebridgeNodeSubnetId = "${var.subnet_id}"
  vpcID                  = "${var.vpc_id}"
  vpcSecurityGroupIds    = ["${var.vpc_security_group_ids}"]
  cloudInitFolder        = "${var.cloudInitFolder}"
}

########################################################################
# Output Definitions
########################################################################
output "sb_hosts_info" {
  value = "${map(
    "sitebridgeName" , local.sitebridgeNameList,
    "instance_ids", module.sitebridgeNode.instance_id,
    "private_ips", module.sitebridgeNode.private_ip_addresses,
    "public_ips", module.sitebridgeNode.public_ip_addresses,
    "hostnames", module.sitebridgeNode.hostnames
  )}"
}

output "hosts_info" {
  value = "${map(
    "instance_ids", module.sitebridgeNode.instance_id,
    "private_ips", module.sitebridgeNode.private_ip_addresses,
    "public_ips", module.sitebridgeNode.public_ip_addresses,
    "hostnames", module.sitebridgeNode.hostnames
  )}"
}
