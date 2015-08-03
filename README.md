# wordpress-site
Sample Wordpress Site using AWS and CloudFormation.

This repo will contain the basics for setting up a highly available, scalable WordPress site, nominally to help restore a previous WordPress instance that had long been shelved in the past. 

## Basic instructions ##
- Prerequisites: AWS key and secret key, and enough permissions to launch ec2 instances, cloudformation, elb, rds. 
- `scripts/`
 - awscli-setup.sh (Designed for ubuntu, but essentially uses Debian package management to install pip, then awscli - my cli of choice).
   -  before running, if on ubuntu, fill in aws_credentials_template with your AWS keys and secret, and aws_config_template for region if not us-east-1
 - **launch_stack.py** - main launcher. Running that will launch a CloudFormation stack including ELB, 2 instances under to start (which will autoscale up 5 nodes if under load), and an RDS instance that's multizone redundant. 
 - template_params.json - parameters filled in, requested by the template
 - wordpress-multi-az-us-east-1-template.json - AWS CloudFormation Sample Template that contained most of the logic of the stack
   - Copied and adjusted for our requirements, started from:  https://s3-us-west-1.amazonaws.com/cloudformation-templates-us-west-1/WordPress_Multi_AZ.template 
- `scripts/ssl/`
  - Helper scripts for generating and installing a self-signed SSL certificate into AWS, required for the SSL termination on the ELB. For some reason the ssl-setup.sh script's generated keys are not accepted by AWS, even though essentially the exact same commands in ssl-cert_commands.txt will upload and be recognized by AWS. I've provided both as a reference. In any case an SSL certificate must be uploaded into AWS IAM and the arn value put in template_params.json.
