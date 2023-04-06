#!/bin/bash

PATH=$PATH:/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin

# setup your project
gcloud init

# download prom files
gsutil cp "gs://${GCP_BUCKET_NAME}/*.prom" /opt/life-dashboard/metrics
