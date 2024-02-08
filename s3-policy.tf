data "aws_iam_policy_document" "root_public_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.web_portal.arn,
      "${aws_s3_bucket.web_portal.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "wwww_public_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.web_portal_redirect.arn,
      "${aws_s3_bucket.web_portal_redirect.arn}/*",
    ]
  }
}
