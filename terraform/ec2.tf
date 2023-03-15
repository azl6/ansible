resource "aws_instance" "AnsibleControlNode" {
  ami           = "ami-0b0d54b52c62864d6"
  instance_type = "t2.micro"
  key_name      = "AnsibleKey"

  tags = {
    "Name" = "Ansible-Control-Node"
  }
}

resource "aws_instance" "RHELManagedNode" {
  ami           = "ami-0b0d54b52c62864d6"
  instance_type = "t2.micro"
  key_name      = "AnsibleKey"

  tags = {
    "Name" = "RHEL-Managed-Node"
  }
}
