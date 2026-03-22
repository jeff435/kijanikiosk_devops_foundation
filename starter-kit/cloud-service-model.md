# CLOUD SERVICE MODEL ANALYSIS

##Recomendation: Hybrid Iaas + Paas

##Iaas (Infastructure as a service)
**Used for:**Networking, security, and foundational infastructure
- VPC with use of public or private subnets
- security groups and IAM roles
- complete control over network configuration

##Pass (Platform as a service)
- ** Used for:**Application hosting and managed services
- AWS ECS with Fargate for containers
- AWS RDS for managed database
- AWS S3 for object storage

## why not Saas (Software as as service) only?
SAAS would limit our ability to;
- impliment custom network segmentation
- Design least privilege IAM policies
- Configure multi-AZ reliability
