FROM rockylinux:8
MAINTAINER madebymode

ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000

# update dnf
RUN dnf -y update
RUN dnf -y install dnf-utils
RUN dnf clean all

# install epel-release
RUN dnf -y install epel-release

# other binaries
RUN dnf -y install yum-utils mysql rsync wget git sudo which

# Update and install latest packages and prerequisites
RUN dnf update -y \
    && dnf install -y --nogpgcheck --setopt=tsflags=nodocs \
    curl \
    wget \
    gcc-c++ \
    make \
    git \
    bzip2 \
    GraphicsMagick \
    gconf-service  \
    libasound2 \
    libatk1.0-0  \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3  \
    libexpat1  \
    libfontconfig1  \
    libgcc1  \
    libgconf-2-4  \
    libgdk-pixbuf2.0-0  \
    libglib2.0-0  \
    libgtk-3-0 \
    libnspr4  \
    libpango-1.0-0  \
    libpangocairo-1.0-0  \
    libstdc++6  \
    libx11-6  \
    libx11-xcb1  \
    libxcb1  \
    libxcomposite1 \
    libxcursor1  \
    libxdamage1 \
    libxext6  \
    libxfixes3  \
    libxi6 \
    libxrandr2  \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    fonts-liberation \
    libappindicator1  \
    libnss3  \
    lsb-release  \
    xdg-utils \





RUN curl -sL https://rpm.nodesource.com/setup_18.x | bash -

RUN curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo

RUN dnf install -y nodejs \
    yarn \
    && dnf clean all && dnf history new

RUN echo 'Creating notroot docker user and group from host' && \
    groupadd -g $HOST_USER_GID docker && \
    useradd -lm -u $HOST_USER_UID -g $HOST_USER_GID docker

# give docker user sudo access
RUN usermod -aG wheel docker
# give docker user access to /dev/stdout and /dev/stderror
RUN usermod -aG tty docker

# Ensure sudo group users are not
# asked for a password when using
# sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
