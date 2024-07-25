resource "aws_secretsmanager_secret" "pipeline-credentials" {
    name = "${local.app_name}/${terraform.workspace}/pipeline-user"
}

resource "aws_secretsmanager_secret_version" "pipeline-credentials-version" {
    secret_id     = aws_secretsmanager_secret.pipeline-credentials.id
    secret_string = jsonencode({
        "ACCESS_ID": aws_iam_access_key.svc_pipeline_hrportal_key.id,
        "ACCESS_KEY": aws_iam_access_key.svc_pipeline_hrportal_key.secret
    })
}