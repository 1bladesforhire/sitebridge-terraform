###################################################################################################
# Create Sitebridge VPC
# 192.168.101.0/24 : Total VPC
#   192.168.101.0/25 : First partition
#     192.168.101.0/28: Bastion subnet
#     .... Rest range for future use.
#
# 192.168.101.128/25 : Second partition
# 192.168.101.128/25 : Large subnet for all sitebridge clusters.
##################################################################################################

########################################################################
# 1. Create Sitebridge VPC-1 in AWS: sitebridge-prod-aws-usw2-vpc1
########################################################################
variable "region" {
  default = "us-west-2"
}

provider "aws" {
  assume_role {
    role_arn    = "arn:aws:iam::592790597790:instance-profile/sitebridge-terraform-deploy-aws-devTest"
    external_id = "Terraform"
  }

  region = "${var.region}"
}

data "aws_region" "current" {}

variable "platformName" {
  default = "aws"
}

variable "vpcName" {
  default = "sitebridge-dev-aws-usw2-vpc1"
}

variable "vpcCidrBlock" {
  default = "192.168.101.0/24"
}

variable "vpcNatPoolCidrBlock" {
  default = "100.112.0.0/16"
}

variable "instanceTenancy" {
  default = "default"
}

variable "dnsSupport" {
  default = "true"
}

variable "dnsHostNames" {
  default = "true"
}

resource "aws_vpc" "sitebridge-vpc" {
  cidr_block           = "${var.vpcCidrBlock}"
  instance_tenancy     = "${var.instanceTenancy}"
  enable_dns_support   = "${var.dnsSupport}"
  enable_dns_hostnames = "${var.dnsHostNames}"

  tags {
    Name = "${var.vpcName}"
  }
}

#--------------------------------------
# Create the Internet Gateway
#--------------------------------------
resource "aws_internet_gateway" "sitebridge-vpc-internet-gateway" {
  vpc_id = "${aws_vpc.sitebridge-vpc.id}"

  tags {
    Name = "${var.vpcName}-sitebridge-internet-gateway"
  }
}

#--------------------------------------
# Create the Route Table. At this time you cannot use a Route Table with in-line routes in conjunction with
# any Route resources. Doing so will cause a conflict of rule settings and will overwrite rules.
# Specify any routes one by one via the aws_route resource.
#--------------------------------------
resource "aws_route_table" "sitebridge-vpc-route-table" {
  vpc_id = "${aws_vpc.sitebridge-vpc.id}"

  tags {
    Name = "${var.vpcName}-sitebridge-route-table"
  }
}

#--------------------------------------
# Create route for internet access.
#--------------------------------------
variable "anyCIDRBlock" {
  default = "0.0.0.0/0"
}

resource "aws_route" "sitebridge-internet-access" {
  route_table_id         = "${aws_route_table.sitebridge-vpc-route-table.id}"
  destination_cidr_block = "${var.anyCIDRBlock}"
  gateway_id             = "${aws_internet_gateway.sitebridge-vpc-internet-gateway.id}"
}

#--------------------------------------
# Create flowlog
#--------------------------------------
resource "aws_flow_log" "example" {
  iam_role_arn    = "${aws_iam_role.flowlogsRole.arn}"
  log_destination = "${aws_cloudwatch_log_group.Trust-Netflow.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${aws_vpc.sitebridge-vpc.id}"
}
