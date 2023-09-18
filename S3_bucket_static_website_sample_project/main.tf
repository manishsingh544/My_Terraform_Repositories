#create s3 bucket
resource "aws_s3_bucket" "bucket1" {
  bucket = var.bucketname
}

#Ensure, everything inside bucket is owned by owner itself
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.bucket1.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Make bucket pulic
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.bucket1.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Add ACL
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.bucket1.id
  acl    = "public-read"
}

#output in portal - access public & block public access off

#Add s3 objects for aboutme & error.html
resource "aws_s3_object" "aboutme" {
  bucket       = aws_s3_bucket.bucket1.id
  key          = "aboutme.html"
  source       = "aboutme.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.bucket1.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

#AWS website configuration - enabling static website
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket1.id
  index_document {
    key = "aboutme.html"
  }
  error_document {
    key = "error.html"
  }
  depends_on = [aws_s3_bucket_acl.example]
}
