terraform {
  backend "s3" {
    bucket       = "devops-bootcamp-terraform-cheamirul"
    key          = "terraform-project.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}