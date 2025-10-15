variable "region" {
    type = string
    description = "Deployment region"
    default = "il-central-1"
}
variable "app_port" {
    type = number
    description = "Container port exposed to the ALB"
    default = 80
}

#
