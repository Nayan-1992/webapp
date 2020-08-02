#Create image by updating he latest code from git and push it to ECR
#It uses Dockerfile provided in github repository, must be on root of repository
echo Logging in to Amazon ECR...
$(aws ecr get-login-password --no-include-email --region us-east-1)
REPOSITORY_URI=033484327401.dkr.ecr.us-east-1.amazonaws.com/webapp
IMAGE_TAG=latest
echo Build started on `date`
echo Building the Docker image...
docker build -t $REPOSITORY_URI:$IMAGE_TAG .
docker tag $REPOSITORY_URI:$IMAGE_TAG $REPOSITORY_URI:$IMAGE_TAG
echo Build completed on `date`
echo Pushing the Docker images...
docker push $REPOSITORY_URI:latest
docker push $REPOSITORY_URI:$IMAGE_TAG
#gets the latest task definition
TASK_DEF=$(aws ecs describe-task-definition --task-definition "Cyberdude-app")
#gets the specific containerDefinitions array and exports to a json format which is needed for the register-task-definition function
CONTAINER_DEFS=$(echo $TASK_DEF | jq '.taskDefinition.containerDefinitions' | awk -v ORS= -v OFS= '{$1=$1}1')
#creates a new task definition from the previous definition details
aws ecs register-task-definition --family "Cyberdude-app" --container-definitions $CONTAINER_DEFS
aws ecs update-service --cluster dino-test-qa-system --service webapp --task-definition Cyberdude-app