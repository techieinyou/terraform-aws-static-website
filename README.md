# Static Website in AWS
This Terraform module will create all required AWS resources to host a Static Website on S3 Bucket and distribute using CloudFront CDN.  This module will also host a simple __index.html__ file to show the message **Coming Soon** as a placeholder.

# Pre-requisites

Following is the only requirement to start using this module

1. Create a Hosted Zone in Router 53 with your domain name (sample.com) and
   1. Povide Hosted Zone ID to the variable **hosted_zone_id**.
   2. Assign your domain name to variable **domain_name**. 


# What this module will do?

This module will create below resources:

1. Create a S3 bucket to host your website.
2. Create a S3 bucket to redirect from www.sample.com to sample.com (if you assign variable **need_www_redirect = true**) .
3. Create a Certificate in AWS Certificate Manager (ACM) for the domain (sample.com).  Also add addition name ww.sample.com if you like to redirect from www.sample.com to sample.com.  
4. Create a CloudFront distribution which is a Content Distribution Network (CDN) to speeds up the distribution of your website content to users worldwide. 
5. Create A record in Route 53 Hosted Zone to route traffic to your website.
6. Host a placeholder website with a **Coming Soon** message, if you assign **need_placeholder_website = true**

Now you can host your own website to this S3 bucket.

# Security

## SSL Certificate

This module will create a SSL certificate (issued by AWS) which is used by CloudFront for all HTTPS connections.  We use **TLSv1.2_2021** as Minimum version of the SSL protocol. 

## Access Configuration 
This module offers three options to configure the access to S3 bucket.  You can select your option by assigning OIC, OIA, or Public to the variable **s3_access_method**.  All three methods are explained below. 

### 1. Public Access
All objects in the S3 bucket will have PUBLIC-READ access

### 2. Origin Access Control (OAC)

This module configure Origin Access Control (OAC) on CloudFrond to access objects from S3.  OAC restrict users to access S3 content through CloudFront only.  

**How OAC works**

CloudFront service principal will sign each request with SigV4. The signature will then be included, along with additional data, to form an Authorization header which will be sent to your S3 origin. When your S3 origin receives this request, it will perform the same steps to calculate the signature and compare its calculated signature to the one CloudFront sent with the request. If the signatures match, the request is processed. If the signatures don’t match, the request is denied.

### 3. Origin Access Identity

Thi module will create an Origin Access Identity to restrict access through CloudFront.




