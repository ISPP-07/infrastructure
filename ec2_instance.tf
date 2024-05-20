resource "tls_private_key" "tf_ec2_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "local_file" "tf_ec2_key" {
    content  = tls_private_key.tf_ec2_key.private_key_pem
    filename = "${path.module}/tf_ec2_key.pem"

    # Protect the private key file
    file_permission = "0600"
}

resource "aws_key_pair" "tf_ec2_key" {
    key_name   = "tf_ec2_key"
    public_key = tls_private_key.tf_ec2_key.public_key_openssh
}

resource "aws_instance" "harmony" {
    ami                     = data.aws_ami.amazon_linux_2.id
    instance_type           = "t2.micro"
    key_name                = aws_key_pair.tf_ec2_key.key_name
    vpc_security_group_ids  = [aws_security_group.harmony_security_group.id]

    tags = {
        Name = "HarmonyInstance"
    }
}