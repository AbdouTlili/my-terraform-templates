resource "aws_instance" "web-server" {
    ami = "ami-0ce2cb35386fc22e9"
    instance_type = "t2.micro"
    tags = {
      Name = "web-server"
      Description = "the EC2 for the main web server"
    }
    user_data = <<-EOF
    sudo apt install update
    sudo apt install tree -y
    EOF
    # ssh key to access the machine
    key_name = aws_key_pair.web-key.id
    # networking rule 
    vpc_security_group_ids = [ aws_security_group.ssh-access-web.id ]

}


resource "aws_key_pair" "web-key" {
  public_key = file("./keys/web.pub")
}

resource "aws_security_group" "ssh-access-web" {
  name = "ssh-access"
  description = "Allow ssh access"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

# data "aws_ami" "latest_ubuntu_linux" {
#   most_recent = true
#   owners      = ["canonical"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }

# output "show" {
   
# }