resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-task-bucket"
  acl    = "private"
  region ="ap-south-1"

  tags = {
    Name        = "My_tfbucket"
  }
}
locals {
   s3_origin_id="s3-origin" 
}

 resource "aws_s3_bucket_public_access_block" "s3_public"{
       bucket = "my-tf-task-bucket"


   block_public_acls  = false
   block_public_policy  = false
}

resource "aws_s3_bucket_object" "object" {
  bucket = "my-tf-task-bucket"
   key ="DSC_3110.jpg"
  source ="C:/Users/Prashant/Downloads/DSC_3110.jpg"
  acl = "public-read"
}
  