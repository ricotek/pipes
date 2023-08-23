# Bitbucket Pipeline Pipe - pipe-dotnet-build

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

## Implementation

Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:<br><br>

```yaml
# This is an example of the script that executes the pipe

- &build_only
      pipe: *js-ui-pipe-ref
      variables:
        BUILD_CMD: $BUILD_CMD

# This is an example of the step that calls the script, along with the ECR login script & the sonarqube scan pipe. 
# Both steps can be seen in full implementation here: 
https://bitbucket.org/vitacarerx/prescriptions.ui/src/DEVOPS-3438-Create-Bitbucket-Cloud-Pipe-for-buildingdeploying-components-based-on-Angular/

- &build-only
    name: Build Only
    script:
      - *ecrLogin
      - *setupEnv
      - *build_only
      - *build_scan
```
## Maintenance Note

This pipe uses `atlassian/bitbucket-pipe-release:5.0.1`, which performs some version control on the calling repository. When you need to update the version of this pipe, simply edit `VERSION` in `bitbucket-pipelines.yml`. Do not edit the version in `pipe.yml` or the pipeline will throw an error about being up to date.