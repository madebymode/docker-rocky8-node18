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
    git 

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
