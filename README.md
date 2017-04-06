### Terraform: Autoscaling Group Demo 

Build out an autoscaling group for a fake microservice.

* The fake microservice code is available as a zip file. 
* An S3 bucket is created and the code zip file is uploaded to it
* A new Autoscaling group is created consisting of:

    - A launch config based on a specified AMI
    - An existing Instance Role is applied for S3 access
    - A new security group is created and applied to launch config        
    - NodeJS and the fakems are installed and started via UserData
    - An autoscaling policy is setup to manage number of instances
    - A CloudWatch alarm tracking instance metrics is attached to autoscaling group
* A new ELB is created and instances are registered
* Final output is the ELB url, which can then be used to access fakems

Terraform setup based on:

- Blog - https://aws.amazon.com/blogs/apn/terraform-beyond-the-basics-with-aws/
- Github - https://github.com/awslabs/apn-blog/tree/tf_blog_v1.0/terraform_demo

Graph Image (using GraphViz):

```bash
terraform graph -draw-cycles -type=plan > autoscaling_graph
"c:\Program Files (x86)\Graphviz2.38\bin\dot.exe" -Tpng autoscaling_graph > graph.png
```
