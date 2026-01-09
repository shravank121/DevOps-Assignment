output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "backend_security_group_id" {
  description = "Backend security group ID"
  value       = aws_security_group.backend.id
}

output "frontend_security_group_id" {
  description = "Frontend security group ID"
  value       = aws_security_group.frontend.id
}
