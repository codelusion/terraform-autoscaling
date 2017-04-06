resource "aws_s3_bucket" "codebucket" {
  bucket = "${var.code_bucketname}"
  acl = "private"

  tags {
    Name = "${var.code_bucketname}"
  }
}

resource "aws_s3_bucket_object" "code-zip" {
  bucket = "${aws_s3_bucket.codebucket.bucket}"
  key = "${var.code_keyname}"
  source = "${var.code_filename}"
}

output "s3_codebucket" {
  value = "${aws_s3_bucket.codebucket.bucket}"
}

output "s3_codebucket_keyname" {
  value = "${aws_s3_bucket_object.code-zip.key}"
}