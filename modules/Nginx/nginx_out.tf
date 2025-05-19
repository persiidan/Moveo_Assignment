output "INSTANCE_ID" {
  value = aws_instance.nginx.id
  description = "the created nginx instance's id"
}