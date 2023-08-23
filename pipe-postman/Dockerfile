FROM node:lts

# Install packages to allow apt to use a repository over HTTPS
RUN apt update -y \
    && apt install -y apt-transport-https ca-certificates \
    curl gnupg-agent \
    wget \
    git \
    software-properties-common

# # Install newman & newman-reporter-htmlextra
RUN npm install -g newman \
    && npm install -g newman-reporter-htmlextra

# Clean package manager cache
RUN apt autoclean

# Copy Files
COPY LICENSE.txt pipe.yml README.md /

COPY pipe /pipe
RUN chmod a+x /pipe/*
ENV PATH=/pipe:$PATH

ENTRYPOINT ["pipe.sh"]