resource "aws_key_pair" "AnsibleKey" {
  key_name   = "AnsibleKey"
  public_key = file("./ansibleKey.pub")
}