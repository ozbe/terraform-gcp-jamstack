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
2. [Terraform Setup](#terraform)
4. [Deploy Developer Assets](#deploy-developer-assets)
5. [View assets](#view-assets)

1. [terraform init](#terraform-init)
1. [Environment tfvars](#environment-tfvars)
2. [Workspaces](#workspaces)
3. [Plan](#plan)
4. [Apply](#apply)

## GCP Project
... and service account

We need a GCP Project and Service Account with the Project Owner role. 

You may already a project and SA account already, but these directions will assume that you are starting from scratch.

**TODO** note 

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

## Terraform init

```
$ terraform init
```

## Environment tfvars

Create `test.tfvars` with the variable `project-id` and the PROJECT_ID for your GCP project.

```
# test.tfvars
project_id = "<PROJECT_ID>"
```
 
Now that you've seen an example, go make `test.tfvars`.

## Workspaces

Terraform Workspaces are used to isolate state. Lets make a one for `test`

### Setup
```
$ terraform workspace new test
```

### Select
You use select to change workspaces. When you create a new workspace it is automatcially selected. If you're following along, you shouldn't have to run the command, but you may need it later.

```
$ terraform workspace select test
```

## Plan
After [selecting](#select) your workspace, plan

```
$ terraform plan -out=test_plan -var-file=test.tfvars
```

## Apply

After [selecting](#select) your workspace and running [plan](#plan)
```
$ terraform apply "test_plan""
```

## Migration
**TODO** - https://cloud.google.com/sql/docs/postgres/connect-admin-proxy#macos-64-bit

## Deploy
**TODO**

## Clean up
**FIXME**

Now to undo everything we did.

### Destroy
After [selecting](#select) your workspace
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
