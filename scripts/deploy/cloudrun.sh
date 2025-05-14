gcloud builds submit --tag gcr.io/PROJECT-ID/nextjs-app
gcloud run deploy nextjs-app \
  --image gcr.io/PROJECT-ID/nextjs-app \
  --platform managed \
  --region europe-west1 \
  --allow-unauthenticated \
  --port 8080