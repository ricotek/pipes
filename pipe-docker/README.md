# Bitbucket Pipeline Pipe - pipe-docker

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

## Implementation, Examples & Usage
<a href=https://bitbucket.org/vitacarerx/templates/src/master/bitbucket_pipelines/pipes/bitbucket-pipelines-eks.yml">Follow This Link for an Example</a> 

```yaml 

# This is the strings section where you define your pipes. They can also be defined within a step but this implementation is much cleaner:

strings:
    - &dotnet-pipe-ref vitacarerx/pipe-dotnet:1.0.2
    - &docker-pipe-ref vitacarerx/pipe-docker:1.0.5
    - &git-versioner-pipe-ref vitacarerx/pipe-git-versioner:1.0.13
    - &helm-pipe-ref vitacarerx/pipe-helm:1.1.0

# This is an example of the script that executes the pipe. A build, and publish as well as tag is demonstrated
- &build_publish_tag
    pipe: *docker-pipe-ref
    variables:
      COMPONENT_FULLNAME: $COMPONENT_FULLNAME
      DOCKERFILE_PATH: $DOCKERFILE_PATH
      ECR_NAME: $ECR_NAME

# This is an example of the step that calls the script, along with the ECR login script & the ecr_push
# Both steps can be seen in full implementation here: 
# https://bitbucket.org/vitacarerx/templates/src/master/bitbucket_pipelines/pipes/bitbucket-pipelines-eks.yml

- &build-publish-tag
    oidc: true
    name: Build docker image & push
    artifacts:
      - gitversion.properties
    runs-on:
          - "self.hosted"
          - "active"
          - "linux"
    services:
      - docker-4g
    script:
      - *ecrLogin
      - *gitversionProperties
      - *build_publish_tag
      - *ecr_push

## You must also add the steps to the pipeline section. This can be seen towards the end of the bitbucket-pipelines.yml file shown above for insurance-api.

      - step: *semver-step
      - step: *build-publish-tag
      - step: *helm-pack
      - step:
          <<: *create-release
          deployment: TACO
      - step: *postman-step
  custom:
    manual-deploy:
      - variables:
        - name: BITBUCKET_DEPLOYMENT_ENVIRONMENT
          default: "DEV"
          allowed-values:
            - "COFY"
            - "DEV"
            - "INT"
            - "PATCH"
            - "QA"
            - "TACO"
            - "UAT"
      - step: *semver-step
      - step: *build-publish-tag
      - step: *helm-pack
      - step: *create-release
  pull-requests:
    "**":
      - step: *build-only
```
## Maintenance Note

This pipe uses `atlassian/bitbucket-pipe-release:5.0.1`, which performs some version control on the calling repository. When you need to update the version of this pipe, simply edit `VERSION` in `bitbucket-pipelines.yml`. Do not edit the version in `pipe.yml` or the pipeline will throw an error about being up to date.