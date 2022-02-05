
# Initializes terraform and configures a bucket for remote backend

terraform {
  # Initializes terraform and configures a bucket for remote backend
  backend "gcs" {
    bucket      = "data2bots-bucket"
    prefix      = "terraform/state"
  }
}