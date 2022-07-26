#!/bin/bash

set -e
export AWS_DEFAULT_OUTPUT="json"

VPC_NAME="$USER-jump-vpc-$(date +'%m%d-%H%M')"

echo "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 | jq -r '.Vpc.VpcId')
echo "Created VPC: $VPC_ID"

echo "Tagging vpc name: $VPC_NAME"
aws ec2 create-tags --resources "$VPC_ID" --tags "Key=Name,Value=$VPC_NAME"
echo

echo "Creating Subnet 10.0.0.0/24..."
SUBNET_ID=$(aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block 10.0.0.0/24 --availability-zone us-east-2a | jq -r '.Subnet.SubnetId')
echo "Created Subnet: $SUBNET_ID"
echo

echo "Creating Internet Gateway..."
INTERNET_GATEWAY_ID=$(aws ec2 create-internet-gateway | jq -r '.InternetGateway.InternetGatewayId')
echo "Created Interget Gateway: $INTERNET_GATEWAY_ID"
echo "Attaching Internet Gateway to VPC..."
aws ec2 attach-internet-gateway --vpc-id "$VPC_ID" --internet-gateway-id "$INTERNET_GATEWAY_ID" && echo "Success" || echo "FAILED"
echo

echo "Creating Route Table..."
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id "$VPC_ID" | jq -r '.RouteTable.RouteTableId')
echo "Create 0.0.0.0/0 Route..."
aws ec2 create-route --route-table-id "$ROUTE_TABLE_ID" --destination-cidr-block 0.0.0.0/0 --gateway-id "$INTERNET_GATEWAY_ID" && echo "Success" || echo "FAILED"
echo "Associating Route Table with Subnet..."
aws ec2 associate-route-table  --subnet-id "$SUBNET_ID" --route-table-id "$ROUTE_TABLE_ID" && echo "Success" || echo "FAILED"
echo

echo "Set subnet to assign public IP on launch..."
aws ec2 modify-subnet-attribute --subnet-id "$SUBNET_ID" --map-public-ip-on-launch && echo "Success" || echo "FAILED"
echo

echo "Creating world-ssh security group..."
SG_ID=$(aws ec2 create-security-group --group-name "world-ssh" --description "Security group for SSH access" --vpc-id "$VPC_ID" | jq -r '.GroupId')
echo "Created Security Group: $SG_ID"
echo "Authorize SSH ingress..."
aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --protocol tcp --port 22 --cidr 0.0.0.0/0 && echo "Success" || echo "FAILED"
echo


echo "VPC: $VPC_ID"
echo "Subnet: $SUBNET_ID"