#!/bin/bash

install_awscli () { 
  if which aws > /dev/null ; then
    echo "*** awscli already installed... ***" 
    return 0
  else 
    echo "*** No awscli installed, installing now... ***"
  fi

  echo "*** Updating Ubuntu apt repo ... ***"
    sudo apt-get update 
  if ! which pip ; then
    echo "*** No pip, installing ... ***"
    sudo apt-get install -y python-pip
  fi
  sudo pip install awscli 
}

configure_awscli () { 
  SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  if [ ! -e ~/.aws/config ] ; then
    if [ -e ${SCRIPT_DIR}/aws_config_template ] ; then
	cat ${SCRIPT_DIR}/aws_config_template > ~/.aws/config
	chmod 600 ~/.aws/config
	config="YES"
    fi
  fi
  if [ ! -e ~/.aws/credentials ] ; then
    if [ -e ${SCRIPT_DIR}/aws_credentials_template ] ; then
	cat ${SCRIPT_DIR}/aws_credentials_template > ~/.aws/credentials
	chmod 600 ~/.aws/credentials
	config="YES"
    fi
  fi
  if [ "$config" != "YES" ] ; then
    echo "*** awscli already configured ***"
  fi
}

#Begin main script
install_awscli
configure_awscli


