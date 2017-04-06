variable "aws_region" {}
variable "key_name" {}
variable "instance_role" {}
variable "service_name" {
  default = "fakems"
}
variable "s3_code_bucketname" {
  default = "node9-fakems-zip"
}

variable "s3_code_keyname" {
  default = "fakems.zip"
}

