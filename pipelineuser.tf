##
## PIPELINE USER
##
resource "aws_iam_user" "svc_pipeline_hrportal" {
    name    = "svc_pipeline_hrportal_hrportal-${terraform.workspace}"
}

resource "aws_iam_user_policy" "svc_pipeline_hrportal_policy" {
  name    = "${local.app_name}-${terraform.workspace}"
  user    = aws_iam_user.svc_pipeline_hrportal.name
  policy  =  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
          "${aws_s3_bucket.frontend_bucket.arn}",
          "${aws_s3_bucket.frontend_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "ecs:*",
        "ecr:*",
        "iam:PassRole"
      ],
      "Effect": "Allow",
      "Resource": [
          "*"
      ]
    },
    {
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Effect": "Allow",
      "Resource": [
          "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "svc_pipeline_hrportal_key" {
  user = aws_iam_user.svc_pipeline_hrportal.name
}