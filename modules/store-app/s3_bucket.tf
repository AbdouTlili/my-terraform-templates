resource "aws_s3_bucket" "store_data" {
  bucket = "${var.app_region}-${var.bucket}"
}