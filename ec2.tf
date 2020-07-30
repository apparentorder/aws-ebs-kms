data aws_ssm_parameter al2 {
	name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource aws_default_vpc _ {}

resource aws_instance _ {
	instance_type = "t2.micro"
	iam_instance_profile = aws_iam_instance_profile._.name
	ami = data.aws_ssm_parameter.al2.value
	associate_public_ip_address = true
	vpc_security_group_ids = [aws_security_group.all.id]

	tags = {
		Name = "ebs-kms-demo"
	}
}

resource aws_security_group all {
	name = "ebs-kms-demo-allow-all"

	vpc_id = aws_default_vpc._.id

	ingress {
		from_port = 0
		to_port = 0
		protocol = -1
		cidr_blocks = [ "0.0.0.0/0" ]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = -1
		cidr_blocks = [ "0.0.0.0/0" ]
	}
}

