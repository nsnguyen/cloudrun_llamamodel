export PROJECT_ID=delta-generator-393307
export LOCATION=us-west1
export ARTIFACT_REGISTRY=llama2
export IMAGE_NAME=llama2
export SERVICE_NAME=${IMAGE_NAME}-service
export IMAGE_TAG="latest"

# gcloud builds submit \
#     --project=$PROJECT_ID \
#     --region=$LOCATION \
#     --config cloud_run_config.yaml \
#     --substitutions _REPO_NAME="$REPO_NAME",_SERVICE_NAME="$SERVICE_NAME",_IMAGE_TAG="$IMAGE_TAG" \
#     --verbosity="debug" .

gcloud config set project ${PROJECT_ID}

docker buildx build --platform linux/amd64 -t ${SERVICE_NAME}:${IMAGE_TAG} .

docker tag ${SERVICE_NAME} ${LOCATION}-docker.pkg.dev/${PROJECT_ID}/${ARTIFACT_REGISTRY}/${SERVICE_NAME}

docker push ${LOCATION}-docker.pkg.dev/${PROJECT_ID}/${ARTIFACT_REGISTRY}/${SERVICE_NAME}

./deploy_cloud_run_service.sh
