# Bitbucket Pipeline Pipe - pipe-postman

Build image for dotnet projects

## Prerequisites

Any pipeline which implements this pipe must have access to AWS ECR in order to pull the image. In the following example, the repository has `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` defined:<br><br>

```
- apt update && apt install -y unzip
- curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
- unzip awscliv2.zip
- ./aws/install
- aws ecr get-login-password | docker login --username AWS --password-stdin xxdkr.ecr.us-east-1.amazonaws.com
```

## Implementation & Usage

Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:<br><br>
NOTE: version: pipe-dotnet:1.0.2 is for build only steps version: pipe-dotnet:2.0.0 is for build & publish steps
```yaml
- pipe: vitacarerx/pipe-postman:1.2.1 # for components hosted on EKS
- pipe: vitacarerx/pipe-postman:1.2.1 # for components hosted on IIS
```
## Examples & Usage Currenlty there are no examples as this pipe has not been consumed yet and still in testing phase

Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:<br><br>
```yaml
- pipe: vitacarerx/pipe-postman:1.2.1

```
## Maintenance Note

This pipe uses `atlassian/bitbucket-pipe-release:5.0.1`, which performs some version control on the calling repository. When you need to update the version of this pipe, simply edit `VERSION` in `bitbucket-pipelines.yml`. Do not edit the version in `pipe.yml` or the pipeline will throw an error about being up to date.