resource "aws_iam_role_policy_attachment" "s3ec2access_policy" {
  role       = "${aws_iam_role.s3ec2access-role.name}"
  policy_arn = "${aws_iam_policy.s3ec2access_policy.arn}"
}

resource "aws_iam_instance_profile" "s3ec2access" {
  name = "s3ec2access_profile"
  role = "${aws_iam_role.s3ec2access-role.name}"
}