resource "aws_iam_policy" "s3ec2access_policy" {
  name        = "s3ec2access_policy"
  path        = "/"
  description = "TBD"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
      "Resource": [
          "*"
      ],
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}