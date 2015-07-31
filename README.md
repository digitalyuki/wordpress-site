# wordpress-site
Sample Wordpress Site using AWS and CloudFormation.

This repo will contain the basics for setting up a highly available, scalable WordPress site, nominally to help restore a previous WordPress instance that had long been shelved in the past. 

## Basic instructions ##
`scripts/`
 - awscli-setup.sh (Designed for ubuntu, but essentially uses Debian package management to install pip, then awscli.
   -  before running, if on ubuntu, fill in aws_credentials_template with your AWS keys and secret, and aws_config_template for region if not us-east-1
 - launch_stack.py - main launcher. Running that *should* launch a stack including ELB, 2 instances under it, an RDS instance that's multizone redundant. 
 - template_params.json - parameters filled in, requested by the template
 - wordpress-multi-az-us-east-1-template.json - AWS CloudFormation Sample Template that contained most of the logic of the stack
   - Copied mostly as-is from AWS, something like https://s3-us-west-1.amazonaws.com/cloudformation-templates-us-west-1/WordPress_Multi_AZ.template 
