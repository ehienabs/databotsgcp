
#Installs Google Cloud Provider

provider "google" { 
  project     = var.project_id
  region      = var.region
}