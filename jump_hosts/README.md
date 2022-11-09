1. Install [AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
2. Make sure your aws cli is properly set up using [this documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
3. Create VPC and Subnet using [script](aws_create_jump_vpc.sh)
4. Go to [EC2 console](https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#LaunchInstances) in aws
5. Make sure your region is set to the one you want before proceeding (also verify your vpc and subnet are set for the region you are using)
6. Click launch instances (top right corner)
7. Give the ec2 instance a name
8. Find latest aws fedora AMI for your region https://alt.fedoraproject.org/cloud/ or use your favorite OS type
9. Select a size (I use t3.medium)
10. Use *openshift-qe* key/pair
11. Edit the Network settings and select the vpc and subnet you just selected 
12. Select “Select existing security group” and select *world-ssh*
13. Click 'Create instance'
14. Find instance in list of instances 
15. Once instance is Running copy the *Public IPv4 address*

16. Login: 
'''ssh -i ~/.ssh/openshift-qe.pem root@<ip_address>'''
**If you don't already request access to bitwarden [here](https://source.redhat.com/departments/it/it-information-security/wiki/intro_to_bitwarden_password_management_and_frequently_asked_questions) to be able to get the openshift-qe.pem file to put in an .ssh folder in your home directory)
**NOTE**: these jump hosts will get deleted every 24 hours 
