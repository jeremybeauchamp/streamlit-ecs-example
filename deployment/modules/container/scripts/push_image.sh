LOCAL=$1
REPO_URL=$2
IMAGE_NAME=$3

aws ecr get-login-password | docker login --username AWS --password-stdin $REPO_URL
docker tag $LOCAL $REPO_URL/$IMAGE_NAME:latest
docker push $REPO_URL/$IMAGE_NAME:latest