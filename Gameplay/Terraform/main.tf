resource "google_cloud_run_service" "concept_storyline_dev" {
  name     = "dev-concept-storyline-service"
  location = "us-east1"

  template {
    spec {
      containers {
        image = "us-east1-docker.pkg.dev/blkbox-infrastructure/blkbox-main/blkbox-gameplay/concept-storyline-service:${var.dev_concept_storyline_image_tag}"
      }
    }
  }
}

resource "google_cloud_run_service" "concept_storyline_prod" {
  name     = "prod-concept-storyline-service"
  location = "us-east1"

  template {
    spec {
      containers {
        image = "us-east1-docker.pkg.dev/blkbox-infrastructure/blkbox-main/blkbox-gameplay/concept-storyline-service:${var.prod_concept_storyline_image_tag}"
      }
    }
  }
}


resource "google_cloud_run_service" "messaging_service_dev" {
  name     = "dev-messaging-service"
  location = "us-east1"

  template {
    spec {
      containers {
        image = "us-east1-docker.pkg.dev/blkbox-infrastructure/blkbox-main/blkbox-gameplay/concept-storyline-service:${var.dev_messaging_image_tag}"
      }
    }
  }
}


resource "google_cloud_run_service" "messaging_service_prod" {
  name     = "prod-messaging-service"
  location = "us-east1"

  template {
    spec {
      containers {
        image = "us-east1-docker.pkg.dev/blkbox-infrastructure/blkbox-main/blkbox-gameplay/concept-storyline-service:${var.prod_messaging_image_tag}"
      }
    }
  }
}
