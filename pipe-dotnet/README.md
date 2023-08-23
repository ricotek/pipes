#  Bitbucket Pipeline Pipe - pipe-dotnet

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
- pipe: vitacarerx/pipe-dotnet:2.0.0

```
## Implementation, Examples & Usage
<a href=https://bitbucket.org/vitacarerx/templates/src/master/bitbucket_pipelines/pipes/bitbucket-pipelines-eks.yml">Follow This Link for an Example</a> 

```yaml 

# This is the strings section where you define your pipes. They can also be defined within a step but this implementation is much cleaner:

strings:
    - &dotnet-pipe-ref vitacarerx/pipe-dotnet:1.0.2

# This is an example of the script that executes the pipe
- &build_only
      pipe: *dotnet-pipe-ref
      variables:
        SONAR_TOKEN: $SONAR_TOKEN
        SONAR_SERVER: $SONAR_SERVER
        COVERAGE_REPORT_PATH: $COVERAGE_REPORT_PATH 
        SLN_PATH: $SLN_PATH 
        NUGET_CONFIG_PATH: $NUGET_CONFIG_PATH

# This is an example of the step that calls the script, along with the ECR login script, the sonarqube scan pipe (build_scan) & build and publish
# Both steps can be seen in full implementation here: 
# https://bitbucket.org/vitacarerx/templates/src/master/bitbucket_pipelines/pipes/bitbucket-pipelines-eks.yml

- &build-only
    name: Build Only
    script:
      - *ecrLogin
      - *setupEnv
      - *build_only
      - *build_scan

- &build_and_publish
      pipe: *dotnet-bnp-pipe-ref
      variables:
        SONAR_TOKEN: $SONAR_TOKEN
        SONAR_SERVER: $SONAR_SERVER
        COVERAGE_REPORT_PATH: $COVERAGE_REPORT_PATH 
        SLN_PATH: $SLN_PATH 
        NUGET_CONFIG_PATH: $NUGET_CONFIG_PATH
        CSPROJ_PATH: $CSPROJ_PATH

- &build_scan    
      pipe: sonarsource/sonarqube-quality-gate:1.1.0
      variables:
        SONAR_TOKEN: $SONAR_TOKEN
        REPORT_FILE: .sonarqube/out/.sonar/report-task.txt

## You must also add the steps to the pipeline section. This can be seen towards the end of the bitbucket-pipelines.yml file shown above for insurance-api.

      - step: *semver-step
      - step: *build-and-publish
      - step: *create-package
      - step: *push-package
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
      - step: *build-and-publish
      - step: *create-package
      - step: *push-package
      - step: *create-release
      - step: *postman-step
  pull-requests:
    "**":
      - step: *build-only
```
## Maintenance Note

This pipe uses `atlassian/bitbucket-pipe-release:5.0.1`, which performs some version control on the calling repository. When you need to update the version of this pipe, simply edit `VERSION` in `bitbucket-pipelines.yml`. Do not edit the version in `pipe.yml` or the pipeline will throw an error about being up to date.