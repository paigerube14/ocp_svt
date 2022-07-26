1. Make sure your aws cli is properly set up 
2. Create VPC and Subnet using script
3. Go to EC2 console in aws: https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#LaunchInstances
4. Click launch instances (top right corner)
5. Give the ec2 instance a name
6. Find latest aws fedora AMI for your region https://alt.fedoraproject.org/cloud/ or use your favorite OS type
7. Select a size (I use t3.medium)
8. Use *openshift-qe* key/pair
9. Edit the Network settings and select the vpc and subnet you just selected 
10. Select “Select existing security group” and select *world-ssh*
11. Click 'Create instance'
12. Find instance in list of instances 
13. Once instance is Running copy the *Public IPv4 address*

14. Login: 
'''ssh -i ~/.ssh/openshift-qe.pem root@<ip_address>'''

