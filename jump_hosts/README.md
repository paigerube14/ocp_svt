Make sure your aws cli is properly set up 

Create VPC and Subnet using script

Go to EC2 console in aws: https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#LaunchInstances

Click launch instances

GIve it a name

Find latest aws fedora AMI for your region https://alt.fedoraproject.org/cloud/ or use your favorite OS type

Select a size (I use t3.medium)

Use *openshift-qe* key/pair

Edit the Network settings and select the vpc and subnet you just selected 

Select “Select existing security group” and select *world-ssh*


Create instance 

Find instance in list of instances 
Once instance is Running copy the *Public IPv4 address*

Login: 
ssh -i ~/.ssh/openshift-qe.pem root@<ip_address>

