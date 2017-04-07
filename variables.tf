variable "aws_region" {
  default = "us-west-2"
}
variable "public_key" {}
variable "service_name" {
  default = "hit-counter"
}
variable "s3_code_bucketname" {}

variable "s3_code_keyname" {
  default = "code.zip"
}

