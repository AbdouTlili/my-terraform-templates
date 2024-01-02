resource "aws_instance" "web-server" {
    ami = "ami-0ce2cb35386fc22e9"
    instance_type = "t2.micro"
    tags = {
      Name = "web-server"
      Description = "the EC2 for the main web server"
    }
    # user_data = <<-EOF
    # sudo apt install update
    # sudo apt install tree -y
    # EOF
    provisioner "remote-exec" {
      on_failure = continue
      inline = [ "lsb_release -a",
                # "sudo apt update",
                #   "sudo apt install nginx -y",
                #   "sudo systemctl enable nginx",
                #   "sudo systemctl start nginx",
       ]                  
    }

    provisioner "local-exec" {
      when = create
      command = "echo ${self.public_ip} >>  /home/abdou/projects/terraform/my-terraform-templates/aws-ec2-and-backend/ips.txt"
    }

    provisioner "local-exec" {
      when = destroy
      command = "echo ${self.public_ip} is destroyed >>  /home/abdou/projects/terraform/my-terraform-templates/aws-ec2-and-backend/destroyed.txt"
    }

    connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = file("./keys/web")
    }


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

output "public_ip" {
  value = aws_instance.web-server.public_ip
   
}