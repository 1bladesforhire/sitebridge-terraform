#################################################################################################
# Create Sitebridge Subnets Inside the VPC.
# To create a new subnet, follow the below model and add another section subnet
##################################################################################################
variable "availabilityZone" {
  type = "list"

  default = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c",
    "us-west-2d",
  ]
}

########################################################################
# 1. Create Subnet Name: sitebridge-prod-aws-usw-2-vpc-1-subnet-bastion
########################################################################
variable "subnet0Name" {
  default = "subnet-bastion"
}

variable "subnet0CIDR" {
  default = "192.168.101.0/28"
}

module "subnet-0" {
  source            = "../subnet"
  subnet_name       = "${var.vpcName}-${var.subnet0Name}"
  vpc_id            = "${aws_vpc.sitebridge-vpc.id}"
  subnet_cidr       = "${var.subnet0CIDR}"
  availability_zone = "${var.availabilityZone}"
  igw_id            = "${aws_internet_gateway.sitebridge-vpc-internet-gateway.id}"
}

########################################################################
# 1. Create Subnet Name: sitebridge-prod-aws-usw-2-vpc-1-subnet-1
########################################################################
variable "subnet1Name" {
  default = "subnet-1"
}

variable "subnet1CIDR" {
  type = "list"

  default = [
    "192.168.101.128/27",
    "192.168.101.160/27",
    "192.168.101.192/27",
    "192.168.101.224/27",
  ]
}

module "subnet-1" {
  source            = "../subnet"
  subnet_name       = "${var.vpcName}-${var.subnet1Name}-count.index"
  vpc_id            = "${aws_vpc.sitebridge-vpc.id}"
  subnet_cidr       = "${var.subnet1CIDR}"
  availability_zone = "${var.availabilityZone}"
  igw_id            = "${aws_internet_gateway.sitebridge-vpc-internet-gateway.id}"
}

########################################################################
# 2. Create Subnet Name: sitebridge-prod-aws-usw-2-vpc-1-subnet-2
########################################################################
variable "subnet2Name" {
  default = "subnet-2"
}

variable "subnet2CIDR" {
  default = "192.168.101.16/28"
}

module "subnet-2" {
  source            = "../subnet"
  subnet_name       = "${var.vpcName}-${var.subnet2Name}"
  vpc_id            = "${aws_vpc.sitebridge-vpc.id}"
  subnet_cidr       = "${var.subnet2CIDR}"
  availability_zone = "${var.availabilityZone}"
  igw_id            = "${aws_internet_gateway.sitebridge-vpc-internet-gateway.id}"
}
