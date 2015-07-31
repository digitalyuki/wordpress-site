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
  if [ ! -e ~/.aws/config ] ; then
    aws configure
  else
    echo "*** awscli already configured ***"
  fi
}

#Begin main script
install_awscli
configure_awscli


