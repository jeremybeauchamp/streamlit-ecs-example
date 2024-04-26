URL=$1
LOCAL_IMAGE=$2
REMOTE_IMAGE=$3
REGION=$4

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $URL
docker tag $IMAGE $URL/$REMOTE_IMAGE:latest
docker push $URL/$REMOTE_IMAGE:latest