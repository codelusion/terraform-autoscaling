variable "availability_zones" {
  default = "us-west-2a,us-west-2b,us-west-2c"
  description = "availability zones to deploy instances to"
}
variable "asg_min" {
  default = "2"
  description = "minimum instance count in autoscaling group"
}
variable "asg_max" {
  default = "6"
  description = "maximum instance count in autoscaling group"
}
variable "asg_desired" {
  default = "2"
  description = "desired instance count in autoscaling group"
}

variable "asg_name" {
  description = "name of autoscaling group"
}
variable "asg_launch_config_id" {
  description = "asg unique id"
}
variable "asg_elb_name" {
  description = "associated elb name"
}