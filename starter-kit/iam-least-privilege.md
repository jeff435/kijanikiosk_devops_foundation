# IAM leat privilege policy design

## Application: order processing service

## Required Permissions
- Read orders from sqs queue
- write orders to dynamoDB table 
-log application events to cloudWatch

## Least privilege policy

'''json
{ 
   "version": "2012-10-17",
   "Statement": [

   { 
     "Effect": "Allow"
     "Action": [
         "sqs:"Receive message",
         "sqs:DeleteMessage",
         "sqs:GetqueueAttributes"
     ],
     "Resources": "arn:aws:sqs:us-east-1 :123456789012:order-queue"
   },
   {
     "Effect": "Allow",
     "Action":[
        "dynamodb:PutItem"
        "dynamodb:GetItem"
     ],
     "Resources": "arn:aws:dynamodb:us-east-1:123456789012:table/orders"
   },
   {
        "Effect":"Allow"
        "Action": [
            "logs:createlogstream",
            "logs:PutlogEvents"
          ],
          "Resource":"arn:aws:logs:us-east-1 :123456789012:*"
         }
       ]
    }
