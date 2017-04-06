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
  iam_instance_profile = "${var.launch_instance_role}"
  user_data       = "${data.template_file.userdata_file.rendered}"
  key_name        = "${var.launch_cfg_keypair_name}"
}

output "ms_launch_config_id" {
  value = "${aws_launch_configuration.ms_launch_cfg.id}"
}

