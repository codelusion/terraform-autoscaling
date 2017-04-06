variable "aws_region" {
  default = "us-west-2"
}
variable "instance_type" {
  default = "t2.nano"
}
# Amazon Linux AMI
# Most recent as of 2015-12-02
variable "aws_amis" {
  type = "map"
  default = {
    #Amazon Linux AMI 2016.09.1 (HVM), SSD Volume Type - ami-f173cc91
    us-west-2 = "ami-f173cc91"
  }
}

variable "launch_cfg_name" {
  description = "launch configuration name"
}
variable "launch_cfg_sg_id" {
  description = "id of security group to apply to instances"
}
variable "launch_cfg_keypair_name" {
  description = "key pair name to use for ssh access"
}
variable "launch_instance_role" {
  description = "instance role to assign"
}
variable "code_zipfile" {
  description = "S3 object key referring to zipped code"
}
variable "service_name" {
  description = "name of service set by PM2 process manager"
}

