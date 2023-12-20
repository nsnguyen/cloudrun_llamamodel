gcloud run deploy "$SERVICE_NAME" \
  --image "$LOCATION-docker.pkg.dev/$PROJECT_ID/$ARTIFACT_REGISTRY/$SERVICE_NAME:$IMAGE_TAG" \
  --region="$LOCATION" \
  --allow-unauthenticated \
  --set-env-vars PROJECT_ID="$PROJECT_ID" \
  --memory=8Gi \
  --cpu=2 \
  --timeout=3600