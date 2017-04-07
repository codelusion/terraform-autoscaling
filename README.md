Terraform: Autoscaling Group Demo 
-------------------------------------

Build out an autoscaling group for a  microservice. 

Inputs 
------
Inputs are set in file `terraform.tfvars`. They are:

* S3 Bucket Name: must be unique
* Public Key (string): This is the key pair used to access instance and trigger auto-scaling

Outline
--------

* The  microservice code is available as a zip file: `files/hit-counter-master.zip`
* An S3 bucket is created and the code zip file is uploaded to it
* A new Autoscaling group is created consisting of:

    - A launch config based on a specified AMI (defaults to an AMI from us-west-2)
    - An Instance Role is applied for S3 Read-Only access
    - A new security group is created and applied to launch config        
    - NodeJS, PM2 (process manager) and the microservice are installed and started via UserData
    - An autoscaling policy is setup to manage number of instances
    - A CloudWatch alarm tracking instance metrics is attached to autoscaling group
* A new ELB is created and instances are registered

Demo:
---

* Run `terraform plan`, follow instructions as needed.

    -  `terraform init` is needed to initialize 
    - View output of `terraform plan` to see what will be created
* Run `terraform run` to start provisioning resources
    
    - final output will be the Elastic Load Balancer URL
    - ELB url format: `http://ms-elb-xxxxxxx.<region>.elb.amazonaws.com/`)
    - Accessed via browser, outputs JSON :  `{"hits": NNN,"name":"hit-counter-pid-XXX","host":"ip-XXX-XXX-XXX-XXX"}`

* Subscribe to SNS topic `hit-counter-asg` under AWS Console > SNS > Topics `hit-counter-asg`

    - Choose EMAIL or SMS as protocol and confirm subscription
* Find newly created instance under AWS Console > EC2 > Name `ms_asg` and lookup it's public IP
* Use the SSH Private Key (pair of public key specified earlier) to access instance
    - Access using `ssh -i <private_key_file> ec2-user@<public ip>`
* Using the `stress` tool, simulate high CPU Utilization and trigger the scaling up of instances.
```bash
stress --cpu 2
```



Terraform setup based on:
-------------------------

- Blog - https://aws.amazon.com/blogs/apn/terraform-beyond-the-basics-with-aws/
- Github - https://github.com/awslabs/apn-blog/tree/tf_blog_v1.0/terraform_demo

- Autoscaling Stack: https://github.com/unifio/terraform-aws-asg

Dependency graph generation (using GraphViz):
----------------------------

```bash
terraform graph -draw-cycles -type=plan > autoscaling_graph
"c:\Program Files (x86)\Graphviz2.38\bin\dot.exe" -Tpng autoscaling_graph > graph.png
```
