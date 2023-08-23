FROM mcr.microsoft.com/dotnet/sdk:6.0

ENV DEBIAN_FRONTEND=noninteractive
ENV NO_COLOR=true

COPY pipe /pipe
RUN chmod a+x /pipe/*
ENV PATH=/pipe:$PATH

# Copy Files
COPY LICENSE.txt pipe.yml README.md /

ENTRYPOINT ["semver.sh"]