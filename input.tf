variable "name" {
  description = "String to use as name for objects"
  type        = string
}

variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default = {
    Developer   = "StratusGrid"
    Provisioner = "Terraform"
  }
}

variable "memory_size" {
  description = "MB of memory function can use"
  type        = number
  default     = 128
}

variable "timeout_sec" {
  description = "Number of seconds before Lambda times out"
  type        = number
  default     = 60
}


variable "schedule_expression" {
  description = "Cron or Rate expression for how frequently the lambda should be executed by cloudwatch events"
  type        = string
  default     = "cron(0 8 * * ? *)"
}


variable "service_name" {
  description = "name of the service"
  type        = string
}

variable "cluster_name" {
  description = "name of the cluster"
  type        = string
}

variable "force_new_deployment" {
  description = "will force new delpoyment of ECS"
  type        = bool
  default     = true
}