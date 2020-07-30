resource aws_kms_key _ {
	description = "ebs-kms-demo-nondefault-key"
	deletion_window_in_days = 7
}

output ebs-kms-demo-nondefault-key {
	value = aws_kms_key._.key_id
}

