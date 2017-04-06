resource "aws_elb" "ms_elb" {
  name = "${var.elb_name}"

  # The same availability zone as our instances
  availability_zones = ["${split(",", var.availability_zones)}"]
  //  subnets = ["${var.public_subnet_id}"]
  //  security_groups = ["${var.webapp_http_inbound_sg_id}"]

  listener {
    instance_port     = "${var.elb_instance_port}"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:3000/health"
    interval            = 30
  }
  tags {
    Name = "ms_elb"
  }
}

output "ms_elb_name" {
  value = "${aws_elb.ms_elb.name}"
}

output "ms_elb_url" {
  value = "${aws_elb.ms_elb.dns_name}"
}