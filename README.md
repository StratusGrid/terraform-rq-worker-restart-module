<!-- BEGIN_TF_DOCS -->
# terraform-rq-worker-restart-module
GitHub: [StratusGrid/terraform-rq-worker-restart-module](https://github.com/StratusGrid/terraform-rq-worker-restart-module)
## Example
```hcl
module "terraform-rq-worker-restart-module" {
  source   = "StratusGrid/terraform-rq-worker-restart-module/aws"
  version  = "1.1.0"
  # source   = "github.com/StratusGrid/terraform-rq-worker-restart-module"

  name                = "${var.name_prefix}-ecs-service-restart${local.name_suffix}"
  input_tags          = merge(local.common_tags, {})
  memory_size         = 128
  timeout_sec       = 60
  schedule_expression = "cron(0 8 * * ? *)"
  service_name        = "my-rqworker-service"
  cluster_name        = "my-cluster"
  force_new_deployment= true
}
```
## StratusGrid Standards we assume
- All resource names and name tags shall use `_` and not `-`s
- The old naming standard for common files such as inputs, outputs, providers, etc was to prefix them with a `-`, this is no longer true as it's not POSIX compliant. Our pre-commit hooks will fail with this old standard.
- StratusGrid generally follows the TerraForm standards outlined [here](https://www.terraform-best-practices.com/naming)
## Repo Knowledge
This terraform module serves the purpose of force deploying a specificed ECS cluster utilizing an AWS Cron job
## Documentation
This repo is self documenting via Terraform Docs, please see the note at the bottom.
### `LICENSE`
This is the standard Apache 2.0 License as defined [here](https://stratusgrid.atlassian.net/wiki/spaces/TK/pages/2121728017/StratusGrid+Terraform+Module+Requirements).
### `outputs.tf`
The StratusGrid standard for Terraform Outputs.
### `README.md`
It's this file! I'm always updated via TF Docs!
### `tags.tf`
The StratusGrid standard for provider/module level tagging. This file contains logic to always merge the repo URL.
### `variables.tf`
All variables related to this repo for all facets.
One day this should be broken up into each file, maybe maybe not.
### `versions.tf`
This file contains the required providers and their versions. Providers need to be specified otherwise provider overrides can not be done.
## Documentation of Misc Config Files
This section is supposed to outline what the misc configuration files do and what is there purpose
### `.config/.terraform-docs.yml`
This file auto generates your `README.md` file.
### `.github/workflows/pre-commit.yml`
This file contains the instructions for Github workflows, in specific this file run pre-commit and will allow the PR to pass or fail. This is a safety check and extras for if pre-commit isn't run locally.
### `examples/*`
The files in here are used by `.config/terraform-docs.yml` for generating the `README.md`. All files must end in `.tfnot` so Terraform validate doesn't trip on them since they're purely example files.
### `.gitignore`
This is your gitignore, and contains a slew of default standards.
---
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.12 |
## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.event](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.function_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.function_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.function_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.function_policy_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_event_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | name of the cluster | `string` | n/a | yes |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | will force new delpoyment of ECS | `bool` | `true` | no |
| <a name="input_input_tags"></a> [input\_tags](#input\_input\_tags) | Map of tags to apply to resources | `map(string)` | <pre>{<br>  "Developer": "StratusGrid",<br>  "Provisioner": "Terraform"<br>}</pre> | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | MB of memory function can use | `number` | `128` | no |
| <a name="input_name"></a> [name](#input\_name) | String to use as name for objects | `string` | n/a | yes |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | Cron or Rate expression for how frequently the lambda should be executed by cloudwatch events | `string` | `"cron(0 8 * * ? *)"` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | name of the service | `string` | n/a | yes |
| <a name="input_timeout_sec"></a> [timeout\_sec](#input\_timeout\_sec) | Number of seconds before Lambda times out | `number` | `60` | no |
## Outputs

No outputs.
---
Note, manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml`
<!-- END_TF_DOCS -->