#data to get the ami for the ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# EC2 instance 
resource "aws_instance" "main-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.allow-ssh.id ]
  subnet_id = aws_subnet.main-public-subnet.id

  key_name = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "main-server"
  }

}


resource "aws_key_pair" "ssh-key" {
  public_key = file("./keys/ec2.pub")
}


output "public_ip" {
  value = aws_instance.main-server.public_ip
}