FROM octopusdeploy/octo

RUN apk add bash

# Copy Files
COPY LICENSE.txt pipe.yml README.md /
COPY templates /templates
COPY pipe /pipe
RUN chmod a+x /pipe/*
ENV PATH=/pipe:$PATH

ENTRYPOINT ["pipe.sh"]