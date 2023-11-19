#!/bin/bash
aws_access_key_id=
aws_secret_access_key=
default_region="us-east-1"  
default_output_format="json"  

path="/home/ec2-user/ansible"

if [ ! -d "~/.aws" ]; then
    mkdir ~/.aws
fi


touch ~/.aws/credentials config


# Create or update the AWS CLI credentials file
cat <<EOL > ~/.aws/credentials
[default]
aws_access_key_id = $aws_access_key_id
aws_secret_access_key = $aws_secret_access_key
EOL

# Create or update the AWS CLI config file
cat <<EOL > ~/.aws/config
[default]
region = $default_region
output = $default_output_format
EOL

echo "AWS credentials configured successfully."

cd $path
 
sudo ansible-playbook -i inventory.py playbook.yaml  --key-file master-key.pem
