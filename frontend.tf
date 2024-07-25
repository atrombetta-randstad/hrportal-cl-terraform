resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "${local.app_name}-frontend-${terraform.workspace}"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for frontend"
}
data "aws_iam_policy_document" "frontend_s3_policy_document" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.frontend_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "frontend_s3_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id
  policy = data.aws_iam_policy_document.frontend_s3_policy_document.json
}
resource "aws_cloudfront_distribution" "hrportal_dist" {
  enabled             = true
  aliases             = [var.frontend_domain_name]
  default_root_object = "index.html"
  wait_for_deployment = false

  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.frontend_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.frontend_bucket.id
    viewer_protocol_policy = "redirect-to-https" # other options - https only, http
    compress               = true

    forwarded_values {
      headers      = []
      query_string = true

      cookies {
        forward = "all"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.redirect.arn
    }

  }

    restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_function" "redirect" {
  name    = "${local.app_name}-cloudfrontfunction-${terraform.workspace}"
  runtime = "cloudfront-js-1.0"
  #comment = "my function"
  publish = true
  code    = file("function/function.js")
}