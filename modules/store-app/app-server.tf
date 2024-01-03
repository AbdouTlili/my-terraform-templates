resource "aws_instance" "app_server" {
    ami = var.ami
    instance_type = var.instance_type
    tags = {
        "Name" = "${var.app_region}-app-server"
    }

    depends_on = [ aws_s3_bucket.store_data, aws_dynamodb_table.store_db]
  
}