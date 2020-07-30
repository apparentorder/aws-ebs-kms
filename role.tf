resource aws_iam_instance_profile _ {
	name = "ebs-kms-demo"
	role = aws_iam_role._.name
}

resource aws_iam_role _ {
	name = "ebs-kms-demo"

	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Action = "sts:AssumeRole"
				Principal = { Service = "ec2.amazonaws.com" }
				Effect = "Allow"
			}
		]
	})
}

resource aws_iam_role_policy_attachment ssm {
	role = aws_iam_role._.name
	policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource aws_iam_role_policy_attachment csi {
	role = aws_iam_role._.name
	policy_arn = aws_iam_policy.csi.arn
}

resource aws_iam_role_policy_attachment demo {
	role = aws_iam_role._.name
	policy_arn = aws_iam_policy.demo.arn
}

resource aws_iam_policy demo {
	name = "ebs-kms-demo-misc"

	policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Action = [
					"kms:ListAliases",
					"kms:DescribeKey",
					"ec2:GetEbsDefaultKmsKeyId",
					"ec2:ModifyEbsDefaultKmsKeyId",
					"ec2:ResetEbsDefaultKmsKeyId",
				]
				Effect = "Allow"
				Resource = "*"
			}
		]
	})
}

resource aws_iam_policy csi {
	name = "ebs-kms-demo-csi"

	# https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/v0.4.0/docs/example-iam-policy.json
	policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

