FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy

# Install packages to allow apt to use a repository over HTTPS
RUN apt update -y \
    && apt install -y apt-transport-https ca-certificates \
    curl gnupg-agent \
    wget \
    git \
    openssh-client \
    software-properties-common

# Install helm
RUN wget https://get.helm.sh/helm-v3.11.3-linux-amd64.tar.gz \
    && tar xvzf helm-v3.11.3-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin 
# Clean package manager cache
RUN apt autoclean

# Copy Files
COPY LICENSE.txt pipe.yml README.md /
COPY templates /templates
COPY pipe /pipe
RUN chmod a+x /pipe/*
ENV PATH=/pipe:$PATH

ENTRYPOINT ["pipe.sh"]