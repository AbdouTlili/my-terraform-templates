module "europe-store" {
    source = "../modules/store-app"
    ami = "ami-0ce2cb35386fc22e9"
    app_region = "us-west-2"
}