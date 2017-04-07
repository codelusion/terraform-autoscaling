variable "availability_zones" {
  default = "us-west-2a,us-west-2b,us-west-2c"
}


variable "elb_instance_port" {
  description = "instance port to monitor for health"
}
variable "elb_name" {
  description = "elb name"
}
