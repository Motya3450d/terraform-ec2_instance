provider "aws" {}


resource "private_key" "my_private_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "my_key_pair" {
    key_name = "emp-web-key"
    public_key = private_key.my_private_key.public_key_openssh
}

resource "aws_instance" "my_instance"{
    count = 1

    ami = "ami-0a261c0e5f51090b1"
    instance_type = "t2.micro"
    key_name = aws_key_pair.my_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.my_group.id]
    user_data = file("user_data.sh")

    tags = {
        Name = "My Ubuntu Server"
        Owner = "Mernik Matvii"
        Project = "Terraform project"
    }
}

resource "aws_eip" "my_eip" {
  instance = aws_instance.my_instance[0].id
  vpc      = false
}

resource "aws_security_group" "my_group" {
    name = "MyInstance Security Group"
    
     ingress {
	    from_port   = 22
	    to_port     = 22
	    protocol    = "tcp"
	    cidr_blocks = ["0.0.0.0/0"]
	  }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

