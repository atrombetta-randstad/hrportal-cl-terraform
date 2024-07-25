## Folder Structure

- **terraform.tfstate.d** - contains tfstates of all workspaces divided in folders
  - **dev** - dev workspace folder
    - **terraform.tfstate** - contains the state of the dev deployment
  - **qa** - qa workspace folder
    - **terraform.tfstate** - contains the state of the qa deployment
  - **prod** - prod workspace folder
    - **terraform.tfstate** - contains the state of the prod deployment
- **tfvars** - contains tfvars files per workspace
  - **dev.tfvars** - this file manage variable assignments for dev
  - **qa.tfvars** - this file manage variable assignments for qa
  - **prod.tfvars** - this file manage variable assignments for prod
- **alb.tf** - loadbalancer and listeners config
- **backend.tf** - ecs cluster, ecr repository and task definition config
- **data.tf** - region and caller identity
- **database.tf** - rds cluster and database secrets config
- **frontend.tf** - cloudfront distribution and s3 bucket config
- **iam_role.tf** - task execution role
- **alb.tf** - terraform providers config
- **network.tf** - vpc and subnets config
- **route53.tf** - dns records for backend and frontend
- **sg.tf** - security group config for ecs and rds
- **users.tf** - developer_user config
- **variables.tf** - input variables

### How to deploy the infrastructure

1. CD to infra folder
1. List the current workspaces `terraform workspace list`
1. Select a workspace with this command `terraform workspace select WORKSPACE` where WORKSPACE is one of the listed in the command above.
1. Initialiaze terraform `terraform init`
1. Make a plan to see the changes `terraform plan -var-file tfvars/dev.tfvars (qa.tfvars or prod.tfvars depending on the workspace selected)
1. Apply the changes `terraform apply -var-file tfvars/dev.tfvars -var 'aws_profile=YOUR_AWS_PROFILE'`. (qa.tfvars or prd.tfvars depending on the workspace selected)
