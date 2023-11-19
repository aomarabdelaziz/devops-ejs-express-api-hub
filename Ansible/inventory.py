#!/usr/bin/env python3.8
import json
import boto3

def fetch_ec2_instances():
    ec2 = boto3.client('ec2', region_name='us-east-1')  

    # Filter instances based on tags
    filters = [
        {'Name': 'tag:Environment', 'Values': ['app-dev']},
        {'Name': 'instance-state-name', 'Values': ['running']}
    ]

    instances = ec2.describe_instances(Filters=filters)
    return instances


def generate_inventory(instances):
    inventory = {
        "_meta": {
            "hostvars": {}
        }
    }

    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            private_ip = instance['PrivateIpAddress']
            public_ip = instance['PublicIpAddress']

            instance_name = ''
            ansible_user = ''
            # Extract the Name tag if it exists
            for tag in instance['Tags']:
                if tag['Key'] == 'Name':
                    instance_name = tag['Value']
                elif tag['Key'] == 'User':
                    ansible_user = tag['Value']


            if instance_name:
                if instance_name not in inventory:
                    inventory[instance_name] = {
                        "hosts": [],
                        "vars": {}
                    }
                inventory[instance_name]['hosts'].append(public_ip)
                inventory["_meta"]["hostvars"][public_ip] = {
                    "ansible_ssh_user": ansible_user,
                    # "ansible_ssh_private_key_file": "/path/to/your/key.pem"  # Modify SSH key file path
                }
    return inventory

if __name__ == "__main__":
    ec2_instances = fetch_ec2_instances()
    dynamic_inventory = generate_inventory(ec2_instances)
    print(json.dumps(dynamic_inventory, indent=4))
