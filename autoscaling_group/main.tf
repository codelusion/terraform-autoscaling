resource "aws_autoscaling_group" "ms_asg" {
  lifecycle {
    create_before_destroy = true
  }
  //  vpc_zone_identifier = ["${var.public_subnet_id}"]
  availability_zones = ["${split(",", var.availability_zones)}"]
  name = "${var.asg_name}"
  max_size = "${var.asg_max}"
  min_size = "${var.asg_min}"
  desired_capacity = "${var.asg_desired}"
  wait_for_elb_capacity = false
  force_delete = true
  launch_configuration = "${var.asg_launch_config_id}"
  load_balancers = ["${var.asg_elb_name}"]

  #vpc_zone_identifier = ["${split(",", var.availability_zones)}"]
  tag {
    key = "Name"
    value = "${var.asg_name}"
    propagate_at_launch = true
  }
}

output "asg_id" {
  value = "${aws_autoscaling_group.ms_asg.id}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.ms_asg.name}"
}
