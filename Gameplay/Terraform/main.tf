resource "google_cloud_run_service" "concept_storyline" {
  name     = "dev-concept-storyline-service"
  location = "us-east1"

  template {
    spec {
      containers {
        image = "us-east1-docker.pkg.dev/blkbox-infrastructure/blkbox-main/blkbox-gameplay/concept-storyline-service:${var.concept_storyline_image_tag}"
      }
    }
  }
}

