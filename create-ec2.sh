#!/bin/bash
IMAGE_ID=ami-03265a0778a880afb
INSTANCE_TYPE=t2.micro
SECURITY_GROUP=sg-0f8c523d0f4ed489b
HOTSTED_ZONE_ID=Z0997824248HW2XYA9N5U
DOMAIN_NAME=venkateshamsonnalia143.online
NAME=$@
for i in $NAME
do 
    echo " Name: $i "
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')

    echo " Name:$i and IP:$IP_ADDRESS "
    aws route53 change-resource-record-sets --hosted-zone-id Z0997824248HW2XYA9N5U --change-batch '{
            "Comment": "CREATE a record ",
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                                    "Name": "'$i.$DOMAIN_NAME'",
                                    "Type": "A",
                                    "TTL": 1,
                                 "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
}}]
}'
done