output "harmony_url" {
    description = "The URL of the app running on the EC2 instance"
    value       = "http://${aws_instance.harmony.public_dns}"
}

output "harmony_ip"{
    description = "The IP address of the app running on the EC2 instance"
    value       = aws_instance.harmony.public_ip
}