#!/bin/bash
#
# Upload frontend assets to GCP
#   Configured to run from project root
#
# Dependencies
#   terraform
#   gsutil
#
set -e

# Get bucket name from terraform
BUCKET=$(terraform -chdir=infrastructure output frontend_bucket | tr -d '"')

# Sync tmp to bucket, removing any old files
gsutil rsync -d -r ./frontend/dist gs://$BUCKET

echo 'Success!'