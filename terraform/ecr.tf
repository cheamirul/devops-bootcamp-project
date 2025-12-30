resource "aws_ecr_repository" "final_project_repo" {
  name                 = "devops-bootcamp/final-project-cheamirul"
  image_tag_mutability = "MUTABLE"
}