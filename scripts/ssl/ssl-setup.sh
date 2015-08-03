#!/bin/bash

certfile="$1"
certkey="$2"
scriptpath="/home/ubuntu/wordpress-site/scripts/ssl"
if [ "$1" == "" ] ; then
  certfile="my-certificate.pem"
fi

if [ "$2" == "" ] ; then
  certkey="my-private-key.pem"
fi
echo -e "Generates Self-Signed Cert for testing and checks AWS for certificate:"
echo -e "\tCertfile: $certfile"
echo -e "\tCertkey: $certkey"

if ! which aws ; then 
  echo "aws cli not installed"
  exit 1
fi

if [ -f $certfile ] ; then 
  echo "$certfile already exists. Remove and rerun the script to regenerate."
  echo "Checking if certificate exists in aws..."
  if aws iam get-server-certificate --server-certificate-name $certfile ; then
    echo "Certificate already exists, exiting..." 
    exit 2
  else
    echo "Attempting to upload certificate to aws..."
    aws iam upload-server-certificate --server-certificate-name $certfile --certificate-body file://$certfile --private-key file://$certkey && exit 0
  fi
  exit 3
fi

cd $scriptpath
openssl genrsa -out $certkey 2048
openssl req -sha256 -new -key $certkey -out my-public-key.pem -days 256 -subj "/C=US/ST=New York/L=New York/O=IT/CN=yukatia.org" -out csr.pem
openssl x509 -req -days 365 -in csr.pem -signkey $certkey -out $certfile
rm csr.pem
if aws iam get-server-certificate --server-certificate-name $certfile >/dev/null ; then
  #Cert exists... overwrite
  echo "Certificate already exists - deleting from aws iam..."
  aws iam delete-server-certificate --server-certificate-name $certfile
fi 

aws iam upload-server-certificate --server-certificate-name $certfile --certificate-body file://$certfile --private-key file://$certkey

#aws iam get-server-certificate --server-certificate-name $certfile 
