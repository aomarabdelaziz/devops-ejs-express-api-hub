data "aws_ami" "latest-amazon-linux-image" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_ami" "latest_ubuntu" {

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}



resource "aws_security_group" "instances_sgs" {
  for_each = var.security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = each.value.ingress

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egress

    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = "${var.env_prefix}-instances-sg"
  }
}



resource "aws_instance" "ansible-ec2-instance" {
  #count                  = length(var.instances)
  depends_on = [
    aws_instance.jenkins-ec2-instance,
    aws_instance.bootstrap-ec2-instance,
    var.eks_cluster_id,
    var.s3_objects,
  ]
  ami                    = data.aws_ami.latest-amazon-linux-image.id
  instance_type          = var.instance_type
  vpc_security_group_ids = values(aws_security_group.instances_sgs)[*].id

  subnet_id = var.subnet_id

  availability_zone = var.avail_zone

  associate_public_ip_address = true

  key_name = var.key-name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = var.key-pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install python3.8 -y",
      "sudo amazon-linux-extras install ansible2 -y",
      "mkdir ansible"
    ]
  }


  provisioner "file" {
    source      = "../Ansible/ansible.cfg"
    destination = "/home/ec2-user/ansible/ansible.cfg"
  }

  provisioner "file" {
    source      = "../Ansible/inventory.py"
    destination = "/home/ec2-user/ansible/inventory.py"
  }

  provisioner "file" {
    source      = "../Ansible/requirements.txt"
    destination = "/home/ec2-user/ansible/requirements.txt"
  }

  provisioner "file" {
    source      = "../Ansible/playbook.yaml"
    destination = "/home/ec2-user/ansible/playbook.yaml"
  }

  provisioner "file" {
    source      = "../Ansible/playbook-invoker.sh"
    destination = "/home/ec2-user/ansible/playbook-invoker.sh"
  }

  provisioner "file" {
    source      = "./master-key.pem"
    destination = "/home/ec2-user/ansible/master-key.pem"
  }




  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ec2-user/ansible/master-key.pem",
      "sudo python3.8 -m pip install -r /home/ec2-user/ansible/requirements.txt",
      "chmod +x /home/ec2-user/ansible/playbook-invoker.sh",
      "chmod +x /home/ec2-user/ansible/inventory.py",
      "sudo /home/ec2-user/ansible/playbook-invoker.sh ${var.application-chart-url}"
    ]
  }

  tags = {
    Name        = "${var.env_prefix}_ansible_server",
    Environment = "app-dev",
    User        = "ec2-user"

  }
}

resource "aws_instance" "jenkins-ec2-instance" {
  ami                    = data.aws_ami.latest_ubuntu.id #"ami-0fc5d935ebf8bc3bc"
  instance_type          = var.instance_type
  vpc_security_group_ids = values(aws_security_group.instances_sgs)[*].id

  subnet_id = var.subnet_id

  availability_zone = var.avail_zone

  associate_public_ip_address = true

  key_name = var.key-name

  tags = {
    Name        = "${var.env_prefix}_jenkins_server",
    Environment = "app-dev"
    User        = "ubuntu"
  }
}


resource "aws_instance" "bootstrap-ec2-instance" {
  ami                    = data.aws_ami.latest-amazon-linux-image.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instances_sgs["sg1"].id]

  subnet_id = var.subnet_id

  availability_zone = var.avail_zone

  associate_public_ip_address = true

  key_name = var.key-name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = var.key-pem
  }


  provisioner "file" {
    source      = "../Ansible/aws_configure.sh"
    destination = "/home/ec2-user/aws_configure.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 777 /home/ec2-user/aws_configure.sh",
      "/home/ec2-user/aws_configure.sh"

    ]
  }

  tags = {
    Name        = "${var.env_prefix}_bootstrap_server",
    Environment = "app-dev"
    User        = "ec2-user"
  }
}
