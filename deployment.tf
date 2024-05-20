resource "null_resource" "deploy_app" {
    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = tls_private_key.tf_ec2_key.private_key_pem
        host        = aws_instance.harmony.public_ip
    } 

    provisioner "file" {
        source      = "deploy"
        destination = "/home/ec2-user/deploy"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /home/ec2-user/deploy/deployment.sh",
            "sh /home/ec2-user/deploy/deployment.sh"
        ]
    }
}