#!/usr/bin/python

import subprocess
import argparse
import os
import json
from datetime import datetime
from pprint import pprint
from subprocess import Popen, PIPE

now = datetime.now()
now_stamp = now.strftime('%Y%m%d-%H%M%S')
stack_name = "HAWordpress"
template_filename = "wordpress-multi-az-us-east-1-template.json"
template_params_filename = "template_params.json"
template_file = os.path.join( os.getcwd(), template_filename ) 
template_params_file = os.path.join( os.getcwd(), template_params_filename )

def parse_it():
  parser = argparse.ArgumentParser(description='Launch cloudformation stack for highly available WordPress site.')
  parser.add_argument('--stack_name', default="{0}-{1}".format(stack_name, now_stamp), type=str, help="Name of the stack that will be launched. \nDefault: %(default)s")
  parser.add_argument('--template_file', default='{0}'.format(template_file), type=str, help="Full path to AWS template file, json required. \nDefault: %(default)s")
  parser.add_argument('--template_params_file', default='{0}'.format(template_params_file), type=str, help="Full path to file with parameters specified required in AWS template. \nDefault: %(default)s")
  args = parser.parse_args()

  return args

def json_parse(thing_to_read, object_type = 'file'):
  if object_type == 'file':
    with open(thing_to_read) as data_obj:
      data = json.load(data_obj)
  else:
    data = json.loads(thing_to_read)
  return data


def launch_stack():
  template_params_json = json_parse(args.template_params_file)
  template_params = template_params_json['Parameters']
  template_param_list = []
  for key, value in template_params.items():
    template_param_list.append('ParameterKey={0},ParameterValue="{1}"'.format(key,value) )
 
  cmd = [ 'aws', 'cloudformation', 'create-stack', 
	'--stack-name', args.stack_name,
	'--template-body', 'file://{0}'.format(args.template_file),
        ]
  try: 
    template_param_list
  except NameError:
    print "No stack_parameters"
    raise
  else: 
    cmd.append('--parameters')
    cmd.extend(template_param_list)
  print '*** About to run: ***\n {0} \n'.format(cmd)
  p = subprocess.Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=PIPE)
  output, err = p.communicate()
  return_code = p.returncode
  print "return_code: {0}".format(return_code)
  if return_code == 0: 
    print "Success!" 
  else: 
    print "Something went wrong..."
  if output: 
    print output
    output_json = json_parse(output, 'string')
    stack_id = output_json['StackId']
    print stack_id
  if err: 
    print err

def check_stack():
  cmd = [ 'aws', 'cloudformation', 'describe-stacks',
	'--stack-name', args.stack_name,
	]
  p = subprocess.Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=PIPE)
  output, err = p.communicate()
  return_code = p.returncode
  if output:
    output_json = json_parse(output, 'string')
    print "Stack Status: {0}".format(output_json["Stacks"][0]["StackStatus"])
  if err:
    print err
  return return_code 
 
if __name__ == "__main__":
  args = parse_it() #build this out to pass parameters manually or launch/delete/check/etc
  if check_stack() == 255:
    print "check_stack is 255"
    launch_stack()
  check_stack()
