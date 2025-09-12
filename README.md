# Plan: Migrating Existing Google Cloud Resources to Terraform & Automating Deployments

## Objective

Bring existing Cloud Run services, jobs, and related resources under Terraform management, and set up an automated CI/CD pipeline with GitHub Actions to handle deployments using Artifact Registry images.

Step 1 : Import Existing Resources

1. Cloud Run Service (manual deploy version)

    Write a minimal Terraform google_cloud_run_service resource with the same name/location.

    Run terraform import google_cloud_run_service.my_service projects/<PROJECT>/locations/<REGION>/services/<SERVICE_NAME>.

2. Cloud Run Job

     Same approach: terraform import google_cloud_run_job.my_job projects/<PROJECT>/locations/<REGION>/jobs/<JOB_NAME>.

3. Service Account(s)

     Define them in Terraform (google_service_account).

    Import them by email:
```
    terraform import google_service_account.my_sa projects/<PROJECT>/serviceAccounts/<SA_EMAIL>
```

4. Workload Identity Federation provider

     Import into Terraform via google_iam_workload_identity_pool and google_iam_workload_identity_pool_provider.

5. Artifact Registry

    Import with:
```
    terraform import google_artifact_registry_repository.my_repo projects/<PROJECT>/locations/<REGION>/repositories/<REPO>
```

✅ After import, run terraform plan to verify no unintended changes.

Step 2 : Validate & Align Configurations

1. After imports, run terraform plan to check drift between what’s defined and what exists.

2. Clean up/adjust Terraform config until plan shows no changes (infra fully in sync).
   

Step 3 : Automate Deployments with GitHub Actions

GitHub Actions workflow:

Build & push versioned image to Artifact Registry.

Extract image URL and pass it as a variable to Terraform.

Run Terraform to update Cloud Run service/job to the new image.

✅ Outcome: Every code change automatically deploys a new version of the application.
