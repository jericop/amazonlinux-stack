ARG BASE_IMAGE="public.ecr.aws/amazonlinux/amazonlinux:2023"

# run-base image
FROM ${BASE_IMAGE} AS run-base

ARG cnb_user=cnb
ARG cnb_uid=1000
ARG cnb_gid=1000
ARG distro_name="Amazon Linux"
ARG distro_version="2023"
ARG GIT_REPO="https://github.com/jericop/amazonlinux-stack"
ARG MAINTAINER="jericop"
ARG homepage=$GIT_REPO
ARG maintainer=$MAINTAINER
ARG stack_id="io.buildpacks.stacks.amazonlinux.2023"
ARG description="Amazon Linux 2023 stack"
ARG metadata=""
ARG released=""
ARG package_metadata=""

LABEL MAINTAINER=$MAINTAINER
LABEL GIT_REPO=$GIT_REPO

RUN dnf update -y \
  && dnf install -y \
    bind-utils \
    findutils \
    git-core \
    hostname \
    openssl \
    shadow-utils \
    sqlite \
    whois \
  && dnf clean all

# run-base-cnb image
FROM run-base AS run-base-cnb

RUN groupadd ${cnb_user} --gid ${cnb_gid} \
  && useradd --uid ${cnb_uid} --gid ${cnb_gid} -m -s /bin/bash ${cnb_user}

LABEL io.buildpacks.stack.description=${description}
LABEL io.buildpacks.stack.distro.name=${distro_name}
LABEL io.buildpacks.stack.distro.version=${distro_version}
LABEL io.buildpacks.stack.homepage=${homepage}
LABEL io.buildpacks.stack.id=${stack_id}
LABEL io.buildpacks.stack.maintainer=${maintainer}
LABEL io.buildpacks.stack.metadata=${metadata}
LABEL io.buildpacks.stack.released=${released}
LABEL io.paketo.stack.packages=${package_metadata}

USER ${cnb_uid}:${cnb_gid}

# build-base image
FROM run-base AS build-base

# This includes all packages needed to install python from source
RUN <<EOF
  dnf update -y \
  && dnf install -y \
    curl \
    expat-devel \
    g++ \
    gcc \
    git-core \
    gmp-devel \
    gzip \
    jq \
    libffi \
    libffi-devel \
    make \
    openssl \
    openssl-devel \
    shadow-utils \
    sqlite \
    sqlite-devel \
    tar \
    unzip \
    wget \
    which \
    xz \
    zip \
    zlib \
    zlib-devel \
  && dnf clean all

YJ_URL=https://github.com/sclevine/yj/releases/download/v5.1.0/yj-linux-amd64

if [ $(arch) = "aarch64" ]; then
  YJ_URL=https://github.com/sclevine/yj/releases/download/v5.1.0/yj-linux-arm64
fi

# Install yj (no checksums available)
curl -sSL "$YJ_URL" > /usr/local/bin/yj && chmod +x /usr/local/bin/yj

EOF

# build-base-cnb image
FROM build-base AS build-base-cnb

RUN groupadd ${cnb_user} --gid ${cnb_gid} \
  && useradd --uid ${cnb_uid} --gid ${cnb_gid} -m -s /bin/bash ${cnb_user}

ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}
ENV CNB_STACK_ID=${stack_id}

LABEL io.buildpacks.stack.description=${description}
LABEL io.buildpacks.stack.distro.name=${distro_name}
LABEL io.buildpacks.stack.distro.version=${distro_version}
LABEL io.buildpacks.stack.homepage=${homepage}
LABEL io.buildpacks.stack.id=${stack_id}
LABEL io.buildpacks.stack.maintainer=${maintainer}
LABEL io.buildpacks.stack.metadata=${metadata}
LABEL io.buildpacks.stack.released=${released}
LABEL io.paketo.stack.packages=${package_metadata}

USER ${cnb_uid}:${cnb_gid}
