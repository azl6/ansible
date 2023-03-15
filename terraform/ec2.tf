resource "aws_instance" "AnsibleControlNode" {
  ami           = "ami-0b0d54b52c62864d6"
  instance_type = "t2.micro"
  key_name      = "AnsibleKey"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("./ansibleKey")
  }

  tags = {
    "Name" = "Ansible-Control-Node"
  }
}

output "ControlNodeIp" {
  value = aws_instance.AnsibleControlNode.public_ip
}