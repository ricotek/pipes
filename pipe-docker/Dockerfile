FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy

# Install packages to allow apt to use a repository over HTTPS

RUN apt update -y \
    && apt install -y apt-transport-https ca-certificates \
    curl gnupg-agent \
    software-properties-common 

# ## Add Docker’s official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# ## Verify fingerprint
RUN apt-key fingerprint 0EBFCD88

# ## Set up the stable repository
RUN add-apt-repository -y \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

# ## Update the apt package index & Install the latest version of docker community edition
RUN apt update -y \
    && apt -y install docker-ce docker-ce-cli containerd.io

## Confirm docker is installed and running
RUN docker --version

# Clean package manager cache
RUN apt autoclean

# Copy Files
COPY LICENSE.txt pipe.yml README.md /

COPY pipe /pipe
RUN chmod a+x /pipe/*
ENV PATH=/pipe:$PATH

ENTRYPOINT ["pipe.sh"]