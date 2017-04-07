resource "aws_iam_instance_profile" "hit_counter_profile" {
  name  = "hit-counter-profile"
  role = "${aws_iam_role.hit_counter_role.name}"
}

resource "aws_iam_role" "hit_counter_role" {
  name = "hit-counter-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}


resource "aws_iam_role_policy" "s3readonly_policy" {
  name = "test_policy"
  role = "${aws_iam_role.hit_counter_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

variable "userdata_file" {
  default = "userdata.sh"
}

data template_file "userdata_file" {
  template = <<EOF
#!/bin/bash
sudo -s
yum update -y
yum install -y gcc-c++ make
yum install -y nodejs npm --enablerepo=epel
npm install -g pm2
yum install -y stress
mkdir -p /service
cd /service
# copy code from s3bucket
aws s3 cp s3://${var.code_zipfile} code.zip
unzip code.zip
cd hit-counter-master
npm install
pm2 start index.js --name "${var.service_name}"
EOF
}


resource "aws_launch_configuration" "ms_launch_cfg" {
  lifecycle {
    create_before_destroy = true
  }
  name          = "${var.launch_cfg_name}"
  image_id      = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"

  # Security group
  security_groups = ["${var.launch_cfg_sg_id}"]
  iam_instance_profile = "${aws_iam_instance_profile.hit_counter_profile.id}"
  user_data       = "${data.template_file.userdata_file.rendered}"
  key_name        = "${var.launch_cfg_keypair_name}"
}

output "ms_launch_config_id" {
  value = "${aws_launch_configuration.ms_launch_cfg.id}"
}

