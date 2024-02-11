# Static Website in AWS
This Terraform module will create all required AWS resources to host a Static Website on S3 Bucket and distribute using CloudFront CDN.  This module will also host a simple __index.html__ file to show the message **Coming Soon** as a placeholder.

# Pre-requisites

Following are the pre-requisites to start using this module

1. Create a Hosted Zone in Router 53 with your domain name (eg. sample.com) and
   1. Assign Hosted Zone ID to the variable **hosted_zone_id**.
   2. Assign your domain name to variable **domain_name**. 

2. Define 2 AWS providers. 
   1. One with __region = "us-east-1"__ and alias name **us-east-1**.  This is to provision SSL/TLS certificate in US-East region.
   2. Default AWS provider with any region you would like to create S3 buckets for website hosting

Below is code sample to declare providers  

```
provider "aws" {
  profile = "profile name configured in %USERPROFILE%\.aws\credentials"  
      or 
      access_key = "access key of IAM user created in your aws account"
      secret_key = "access secret of IAM user created in your aws account"
  region  = "any-aws-region"
}

provider "aws" {
  profile = "profile name configured in %USERPROFILE%\.aws\credentials"
      or 
      access_key = "access key of IAM user created in your aws account"
      secret_key = "access secret of IAM user created in your aws account"
  region  = "us-east-1"
  alias = "us-east-1"
}
```


# What will this module do?

This module will create below resources:

1. Create a S3 bucket to host your website.
2. Create a S3 bucket to redirect from www.sample.com to sample.com (if you assign variable **need_www_redirect = true**) .
3. Create a SSL/TLS Certificate in AWS Certificate Manager (ACM) for the domain (sample.com) in US-East region.  Also add addition name www.sample.com if you like to redirect from www.sample.com to sample.com.  
4. Create a CloudFront distribution which is a Content Distribution Network (CDN) to speeds up the distribution of your website content to your users worldwide. 
5. Create A record in Route 53 Hosted Zone to route traffic to your website.
6. Host a placeholder website with a **Coming Soon** message, if you assign **need_placeholder_website = true**

Now you can host your own website to this S3 bucket.

# Security
## SSL/TLS Certificate

This module will create a SSL/TLS certificate (issued by AWS) which is used by CloudFront for all HTTPS connections.  **TLSv1.2_2021** is configured as Minimum version of the SSL/TLS protocol. 

## Access Configuration 
This module offers three options to configure the access to S3 bucket.  You can select your option by assigning OIC, OIA, or Public to the variable **s3_access_method**.  All three methods are explained below. 

### 1. Public Access
All objects in the S3 bucket will have PUBLIC-READ access

### 2. Origin Access Control (OAC)

This module configure Origin Access Control (OAC) on CloudFrond to access objects from S3.  OAC restrict users to access S3 content through CloudFront only.  

**How OAC works**

CloudFront service principal will sign each request with SigV4. The signature will then be included, along with additional data, to form an Authorization header which will be sent to your S3 origin. When your S3 origin receives this request, it will perform the same steps to calculate the signature and compare its calculated signature to the one CloudFront sent with the request. If the signatures match, the request is processed. If the signatures don’t match, the request is denied.

### 3. Origin Access Identity (OAI)

Thi module will create an Origin Access Identity to restrict access through CloudFront.




