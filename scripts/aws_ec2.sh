# Create ec2 and return Instance_id
INSTANCE_ID=$(aws ec2 run-instances --image-id ${AMI} --count 1 --instance-type c4.xlarge --key-name aws-deploy-key --associate-public-ip-address --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$CI_COMMIT_SHORT_SHA}]" --region ${REGION} | jq -r '.Instances[0].InstanceId')
sleep 90
# Got IP with Instance_id
PUBLIC_IP_ADDRESS=`aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[].Instances[].PublicIpAddress" --output text --region ${REGION}`

# Got Instance_ids from tag
INSTANCE_IDS=`aws ec2 describe-instances --filters "Name=tag:Name,Values=${CI_COMMIT_SHORT_SHA}" --query "Reservations[].Instances[].InstanceId" --output text --region ${REGION}`

# Destory ec2
aws ec2 terminate-instances --instance-ids ${INSTANCE_IDS} --region ${REGION}