terraform {
  backend "s3" {
   bucket = "tfstate-bucket1111"
   key= "terraform.tfstate"
   region = "ap-south-1"
   encrypt = true
  }
}