# set up a bucket to hold our static webpage
resource "aws_s3_bucket" "hello_world_bucket" {
  bucket = var.hello_world_bucket.domain
  acl = "public-read"
}

# upload the static webpage to the bucket
# we can also set the content_type here so that the page will load in a browser. 
resource "aws_s3_bucket_object" "hello_world_bucket_file" {
  bucket = aws_s3_bucket.hello_world_bucket.id
  key    = "index.html"
  source = var.hello_world_bucket.path
  content_type = "text/html"
  etag = filemd5(var.hello_world_bucket.path)
}

# allow S3 to host a static website
resource "aws_s3_bucket_website_configuration" "hello_world_bucket_configuration" {
  bucket = aws_s3_bucket.hello_world_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

# return the url for our bucket
output "hello_world_bucket_url" {
  value = aws_s3_bucket.hello_world_bucket.website_endpoint
}