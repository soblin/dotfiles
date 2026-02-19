FROM ubuntu:22.04

ARG CLANG_VERSION=18

RUN apt-get update && apt-get install -y git curl wget lsb-release software-properties-common

WORKDIR /tmp

ADD --chown=root:root --chmod=777 https://apt.llvm.org/llvm.sh llvm.sh

RUN ./llvm.sh ${CLANG_VERSION}

RUN apt-get update && apt-get install -y \
    clang-${CLANG_VERSION} \
    clang++-${CLANG_VERSION} \
    clang-tidy-${CLANG_VERSION} \
    clangd-${CLANG_VERSION} \
    clang-format-${CLANG_VERSION} \
    libomp-${CLANG_VERSION}-dev \
    libstdc++-12-dev

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 18
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-18 18
RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-18 18
RUN update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-18 18
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-18 18

WORKDIR /workspaces/
