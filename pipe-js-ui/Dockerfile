FROM node:14.19.3

# Install OpenJDK 11
RUN apt update -y \
    && apt install -y openjdk-11-jdk \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install ./google-chrome-stable_current_amd64.deb -y \
    && export CHROME_BIN="/usr/bin/google-chrome" 

# Clean package manager cache
RUN apt autoclean

# Copy Files
COPY LICENSE.txt pipe.yml README.md /

COPY pipe /pipe
RUN chmod a+x /pipe/*
ENV PATH=/pipe:$PATH

ENTRYPOINT ["pipe.sh"]