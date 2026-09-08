ARG BASE_IMAGE="ubuntu:24.04"
FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.description="Development image for PyAsc (non-NPU environment)"
LABEL org.opencontainers.image.source="https://github.com/compiler-team-ru/pyasc-docker"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        git \
        gnupg \
        lcov \
        nano \
        openssh-client \
        rsync \
        software-properties-common \
        sudo \
        unzip \
        vim \
        wget \
        zip \
        zlib1g-dev && \
    wget -LO /usr/share/keyrings/llvm.asc https://apt.llvm.org/llvm-snapshot.gpg.key && \
    echo "deb [signed-by=/usr/share/keyrings/llvm.asc] \
        http://apt.llvm.org/jammy/ llvm-toolchain-jammy-20 main" \
        > /etc/apt/sources.list.d/llvm.list && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        clang-20 \
        clang-format-20 \
        clang-tidy-20 \
        lld-20 \
        python3.11 \
        python3.11-dev && \
    rm -rf /var/lib/apt/lists/*

ARG CCACHE_ARCHIVE_URL
RUN mkdir /tmp/ccache && \
    cd /tmp/ccache && \
    wget -LO ccache.tar.xz "${CCACHE_ARCHIVE_URL}" && \
    tar -xf ccache.tar.xz --strip-components=1 && \
    chmod +x ccache && \
    cp ccache /usr/local/bin/ && \
    rm -r /tmp/ccache

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-20 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-20 100 && \
    update-alternatives --install /usr/bin/lld lld /usr/bin/lld-20 100 && \
    update-alternatives --install /usr/bin/ld.lld ld.lld /usr/bin/ld.lld-20 100 && \
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-20 100 && \
    update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-20 100 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

RUN wget -LO /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python3 /tmp/get-pip.py && \
    python3 -m pip install --no-cache-dir --upgrade setuptools wheel && \
    rm /tmp/get-pip.py

ARG CANN_TOOLKIT_URL
RUN wget -LO cann.run "${CANN_TOOLKIT_URL}" && \
    printf 'y\n2\ny\n' | bash cann.run --full && \
    rm cann.run

RUN --mount=type=bind,target=/tmp/requirements.txt,source=requirements.txt \
    python3 -m pip install --no-cache-dir -r /tmp/requirements.txt && \
    python3 -m pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu

ARG LLVM_ARCHIVE_URL
RUN mkdir /opt/llvm && \
    cd /opt/llvm && \
    wget -LO llvm.tar.gz "${LLVM_ARCHIVE_URL}" && \
    tar xf llvm.tar.gz --strip-components=1 && \
    rm llvm.tar.gz

ENV LLVM_INSTALL_PREFIX="/opt/llvm"

ENV PRE_COMMIT_HOME="/opt/pre-commit-cache"
RUN --mount=type=bind,target=/tmp/.pre-commit-config.yaml,source=.pre-commit-config.yaml \
    cd /tmp && \
    git init && \
    pre-commit install-hooks && \
    rm -r .git

RUN echo "source /usr/local/Ascend/cann/set_env.sh" >> /etc/bash.bashrc
