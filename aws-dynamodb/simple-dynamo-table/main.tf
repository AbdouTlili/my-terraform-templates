resource "aws_dynamodb_table" "employees"{
    name = "employee_skale5"
    hash_key = "EID"
    billing_mode = "PAY_PER_REQUEST"
    attribute {
        name = "EID"
        type = "N"
    }
}

resource "aws_dynamodb_table_item" "employee_item" {
  table_name = aws_dynamodb_table.employees.name
  hash_key = aws_dynamodb_table.employees.hash_key
  item       = <<EOF
    {
        "EID"  : {"N": "2"},
        "name" : {"S": "abdou"},
        "role" : {"S": "Senor DevOps engineer"}
    }
  EOF
}