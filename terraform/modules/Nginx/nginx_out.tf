output "instance_id" {
  value = aws_instance.nginx.id
  description = "the created nginx instance's id"
}