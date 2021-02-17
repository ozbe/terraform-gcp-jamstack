# Terraform GCP Jamstack

## DISCLAIMER
 This repo is NOT operational. 
 
 This project has just been jumpstarted with source from other personal repos that will be modified to meet the goal of this project

## Prereqs
* **FIXME**`glcoud` configured to use an account with `Project Owner` permissions to _the_ GCP Project (`PROJECT_ID`)

## Setup and Deploy

## Steps
**FIXME**

1. [GCP Project](#gcp-project)
2. [Infrastructure](#infrastructure)
3. Backend
  1. Envrionment
  2. Migrate
  3. Deploy
4. Frontend
  1. Envrionment
  2. Deploy
5. View frontend

## GCP Project
... and service account

We need a GCP Project and Service Account with the Project Owner role. 

You may already a project and SA account already, but these directions will assume that you are starting from scratch.

### Create GCP Project

```
# Create project
$ gcloud projects create <PROJECT_ID>

# Get billing ACCOUNT_ID
$ gcloud alpha billing accounts list

# Enable billing
$ gcloud beta billing projects link <PROJECT_ID> --billing-account=<ACCOUNT_ID>

# Set project
$ gcloud config set project <PROJECT_ID>

# Enable Cloud Resource Manager API
gcloud services enable cloudresourcemanager.googleapis.com
```

### Create Terraform Service Account (SA)

```
# Create SA
$ gcloud iam service-accounts create <SA_NAME> --display-name "Terraform Account"

# Assign SA owner role
$ gcloud projects add-iam-policy-binding <PROJECT_ID> --member "serviceAccount:<SA_NAME>@<PROJECT_ID>.iam.gserviceaccount.com" --role "roles/owner"

# Create and download SA key
$ gcloud iam service-accounts keys create <SA_KEY>.json --iam-account <SA_NAME>@<PROJECT_ID>.iam.gserviceaccount.com

# Activate service account 
$ gcloud auth activate-service-account --project=<PROJECT_ID> --key-file=<SA_KEY>.json

# Set gcloud account to SA
$ gcloud config set account <SA_NAME>@<PROJECT_ID>.iam.gserviceaccount.com

# Login
$ gcloud auth application-default login
```

## Infrastructure

We will manage our infrastructure with Terraform. 

### Init

To get started we will make sure we are working in the `infrastructure` folder and init Terraform:
```
$ cd infrastructure
$ terraform init
```

### Environment

Create `test.tfvars` with the required variables `project_id` and `app_db_password`:
* `project_id` is the GCP project id you will be using
* `app_db_password` is a random secure string to use for the backend DB password.

Optionally, you can set `deletion_protection` to false if you want to be able to teardown the infrastructure with `terraform destroy` later. 

```
# test.tfvars
# Required
project_id = "<PROJECT_ID>"
app_db_password     = "<APP_DB_PASSWORD>"
# Optional
deletion_protection = false
```
 
Now that you've seen an example, go make `test.tfvars`.

### Workspace

Terraform Workspaces are used to isolate state. Lets make a one for `test`:
```
$ terraform workspace new test
```

## Plan
After setting up your `test` workspace, now run Terraform plan:
```
$ terraform plan -out=test_plan -var-file=test.tfvars
```

## Apply

After running [plan](#plan) we can apply the changes:
```
$ terraform apply "test_plan""
```

We have not setup all of the infrastructure we will need to run the backend and frontend.

## Backend

The backend is an Apollo Server that with run in a Google Cloud Function.

### Environment

For local development and running migrations the backend requires the databause to be configured via an environment variable.

Create a `.env` file in `/backend` with the variable `DATABASE_URL`:
```
DATABASE_URL="postgresql://app:[PASSWORD]@localhost:5432/app?sslmode=disable"
```
Be sure to replace `[PASSWORD]` with the password you set in `test.tfvars`.

### Migration

1. `./scripts/sql_proxy.sh`
2. `npx prisma init`
3. `npx prisma migrate dev --preview-feature`

### Deploy

1. `npm run deploy`

## Frontend

The frontend is an React app that with be served via Cloud CDN.

### Environment

**TODO** Set API endpoint

### Deploy

1. `./scripts/upload_frontend_assets.sh`

## Clean up

Now to undo everything we did. 

To clean up, we _only_ need to work with the infrastructure and GCP project. 
By removing the infrastructure the frontend and backend are also cleaned up.

### Infrastructure

```
$ terraform destroy -var-file=test.tfvars
```

### Remove service account

```
# List accounts
$ gcloud auth list

# Switch account to one other than SA
$ gcloud config set account <ACCOUNT>

# Revoke SA account
$ gcloud revoke <SA_ACCOUNT>
```

### Delete project

```
% gcloud projects delete <PROJECT_ID>
```
