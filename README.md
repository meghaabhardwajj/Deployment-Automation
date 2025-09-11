Terraform Configuration

Variable.tf


'''variable "concept_storyline_image_tag" {
default = "dev_latest"
}
variable "messaging_image_tag" {
default = "dev_latest"
}
variable "scene_prediction_image_tag" {
default = "dev_latest"
}
variable "user_persona_image_tag" {
default = "dev_latest"
}'''


main.tf

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

Note : main.tf will be modified with more later. This is just a sample file for importing.



Github Yaml File



name: Docker Image Builder & Cloud Run Deploy

on:
  push:
    branches:
      - dev
      - master
      - main

jobs:
  deploy:
    name: CI/CD for Cloud Run
    runs-on: deafult-runner-01
    environment: blkbox-infrastructure
    permissions:
      id-token: write
      contents: read

    steps:
     - name: Check out repository
       uses: actions/checkout@v4  

     - name: GCP Auth
       id: auth
       uses: google-github-actions/auth@v2
       with:
         token_format: access_token
         workload_identity_provider: ${{ vars.WORKLOAD_IDENTITY_PROVIDER }}
         service_account: ${{ vars.SERVICE_ACCOUNT }}

     - name: Login to Artifact Registry
       uses: docker/login-action@v3
       with:
         registry: us-east1-docker.pkg.dev
         username: oauth2accesstoken
         password: ${{ steps.auth.outputs.access_token }}   

     - name: Check Branch
       id: environment_name
       run: |
          if [ "${{ github.ref }}" = "refs/heads/main" ] || [ "${{ github.ref }}" = "refs/heads/master" ]; then
            echo "environment=prod" >> $GITHUB_OUTPUT
          else
            echo "environment=dev" >> $GITHUB_OUTPUT
          fi

     - name: Build & Push Image
       run: make push env=${{ steps.environment_name.outputs.environment }}

     - name: Setup Terraform
       uses: hashicorp/setup-terraform@v3

     - name: Terraform Init
       run: terraform init

     - name: Terraform Plan
       run: terraform plan -var="image_tag=${{ steps.environment_name.outputs.environment }}_latest"

     - name: Terraform Apply
       run: terraform apply -auto-approve -var="image_tag=${{ steps.environment_name.outputs.environment }}_latest"





