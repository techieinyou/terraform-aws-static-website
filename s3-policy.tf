
data "aws_iam_policy_document" "root_access_public" {
  statement {
    principals {
      type        = "*"
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

data "aws_iam_policy_document" "root_access_oac" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.web_portal.arn,
      "${aws_s3_bucket.web_portal.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [format("arn:aws:cloudfront::%s:distribution/%s", data.aws_caller_identity.current.account_id, aws_cloudfront_origin_access_control.oac.id)]
    }
  }
}

data "aws_iam_policy_document" "root_access_oai" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.web_portal.arn,
      "${aws_s3_bucket.web_portal.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}