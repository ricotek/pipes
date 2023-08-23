# Bitbucket Pipeline Pipe - pipe-octo

Build image for octopus cli.

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
NOTE:
```yaml

# this goes under the strings section
- &octo-pipe-ref vitacarerx/pipe-octo:2.0.0 

# this goes under the scripts section
# this script runs helm push, create release, & deploy
- &create_release_deploy 
      pipe: *octo-pipe-ref
      variables:
        OCTOPUS_SERVER_EXT: $OCTOPUS_SERVER_EXT
        OCTOPUS_APIKEY: $OCTOPUS_APIKEY
        BITBUCKET_REPO_SLUG: $BITBUCKET_REPO_SLUG
        BITBUCKET_DEPLOYMENT_ENVIRONMENT: $BITBUCKET_DEPLOYMENT_ENVIRONMENT
        VERSION: $VERSION
        CHART_FULL_PATH: $CHART_FULL_PATH

# this goes under the steps section
# this step pushes the helm chart to octopus, creates the release & deploys it
 &create-release-deploy
    name: Push chart, create release & deploy
    artifacts:
      - gitversion.properties
      - deploy/vps-coracare-insurance-api/*.tgz
      - shared_vars.sh
    services:
      - docker-512m
    script:
      - *ecrLogin
      - *gitversionProperties
      - *exportSharedVars
      - *create_release_deploy
 

```

```
## Implementation, Examples & Usage
<a href=https://bitbucket.org/vitacarerx/templates/src/master/bitbucket_pipelines/pipes/bitbucket-pipelines-eks.yml">Follow This Link for an Example</a> 



# This is the strings section where you define your pipes. They can also be defined within a step but this implementation is much cleaner:
```yaml 

strings:
    - &helm-pipe-ref vitacarerx/pipe-helm:1.3.3
```

``

# This is an example of the the helm pack script. A full example of all the steps can be seen here: https://bitbucket.org/vitacarerx/templates/src/master/bitbucket_pipelines/pipes/bitbucket-pipelines-eks.yml

- &helm_pack
      pipe: *helm-pipe-ref
      variables:
        CHART_PATH: $CHART_PATH
        VERSION: $GITVERSION_MAJORMINORPATCH-$BITBUCKET_BUILD_NUMBER

# This is an example of the step, helm pack..push chart seen below is done by an octopus pipe. See the link above for a full reference.
```yaml 
- &helm-pack
    oidc: true
    name: Helm pack & push
    artifacts:
      - deploy/vps-coracare-insurance-api/*.tgz
    services:
      - docker-512m
    script:
      - *ecrLogin
      - *setupEnv
      - *gitversionProperties
      - *helm_pack
      - *push_chart

```

```

# This is an example of the script that executes the pipe
## Maintenance Note

This pipe uses `atlassian/bitbucket-pipe-release:5.0.1`, which performs some version control on the calling repository. When you need to update the version of this pipe, simply edit `VERSION` in `bitbucket-pipelines.yml`. Do not edit the version in `pipe.yml` or the pipeline will throw an error about being up to date.