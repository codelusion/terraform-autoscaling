# https://raw.githubusercontent.com/hashicorp/terraform/master/examples/aws-asg/main.tf

terraform {
  required_version = "> 0.8.0"
  # store state in S3 bucket
}


# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

resource aws_key_pair "hit_counter_key" {
  key_name = "hit-counter-key"
  public_key = "${var.public_key}"
}

module "sec_group" {
  source = "sec_group"
}

module "s3" {
  source = "s3"
  code_filename = "files/hit-counter-master.zip"
  code_bucketname = "${var.s3_code_bucketname}"
  code_keyname = "${var.s3_code_keyname}"
}


module "launch_config" {
  source = "launch_config"
  launch_cfg_name = "ms_launch_cfg"
  launch_cfg_sg_id = "${module.sec_group.ms_sg_id}"
  launch_cfg_keypair_name = "${aws_key_pair.hit_counter_key.key_name}"
  code_zipfile = "${var.s3_code_bucketname}/${var.s3_code_keyname}"
  service_name = "${var.service_name}"
}

module "elb" {
  source = "elastic_loadbalancer"
  elb_name = "ms-elb"
  elb_instance_port = "3000"
}

module "auto_scaling" {
  source = "autoscaling_group"
  asg_name = "ms_asg"
  asg_launch_config_id = "${module.launch_config.ms_launch_config_id}"
  asg_elb_name = "${module.elb.ms_elb_name}"
  asg_min = "1"
  asg_desired = "1"
  asg_max = "4"
}

## Provisions autoscaling policies and associated resources
module "scale_up_policy" {

  # ASG Policy setup from "github.com/unifio/terraform-aws-asg/policy"
  source = "policy"

  # Resource tags
  policy_name = "${var.service_name}"

  # ASG parameters
  asg_name = "${module.auto_scaling.asg_name}"

  # Notification parameters
  notifications = ["autoscaling:EC2_INSTANCE_LAUNCH_ERROR", "autoscaling:EC2_INSTANCE_TERMINATE_ERROR", "autoscaling:EC2_INSTANCE_LAUNCH", "autoscaling:EC2_INSTANCE_TERMINATE"]

  # Monitor parameters
  adjustment_type     = "PercentChangeInCapacity"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  cooldown            = 100
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  period              = 60
  scaling_adjustment  = 1
  threshold           = 80
}


output "elb_url" {
 value = "${module.elb.ms_elb_url}"
}
