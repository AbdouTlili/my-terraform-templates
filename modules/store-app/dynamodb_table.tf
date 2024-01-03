resource "aws_dynamodb_table" "store_db" {
    name = "store_data"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "ItemID"

    attribute {
      name = "ItemID"
      type = "N"
    }
  
}