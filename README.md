# terraform-rq-worker-restart-module
This terraform module serves the purpose of force deploying a specificed ECS cluster utilizing an AWS Cron job

### Example Usage:
```
module "terraform-rq-worker-restart-module" {
  source   = "StratusGrid/terraform-rq-worker-restart-module/aws"
  version  = "1.1.0"
  # source   = "github.com/StratusGrid/terraform-rq-worker-restart-module"

  name                = "${var.name_prefix}-ecs-service-restart${local.name_suffix}"
  input_tags          = merge(local.common_tags, {})
  memory_size         = 128
  timeoutsecond       = 60
  schedule_expression = "cron(0 8 * * ? *)"
  service_name        = "my-rqworker-service"
  cluster_name        = "my-cluster"
  force_new_deployment= true
}
```