FROM ubuntu:22.04

ARG CLANG_VERSION=18

# /* cspell:disable-next-line */
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y tzdata

RUN apt-get install -y ubuntu-desktop

RUN apt-get install -y curl git ripgrep

# cspell:disable-next-line
RUN add-apt-repository ppa:ubuntuhandbook1/emacs && \
    apt-get update

# emacs30 as of 2026/02/28
RUN apt-get install -y emacs

# for clangd
RUN apt-get update && apt-get install -y git curl wget lsb-release software-properties-common

WORKDIR /tmp

ADD --chown=root:root --chmod=777 https://apt.llvm.org/llvm.sh llvm.sh

RUN ./llvm.sh ${CLANG_VERSION}

# cSpell:disable
RUN apt-get update && apt-get install -y \
    clang-${CLANG_VERSION} \
    clang++-${CLANG_VERSION} \
    clang-tidy-${CLANG_VERSION} \
    clangd-${CLANG_VERSION} \
    clang-format-${CLANG_VERSION} \
    libomp-${CLANG_VERSION}-dev \
    libstdc++-12-dev
# cSpell:eable

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 18
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-18 18
RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-18 18
RUN update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-18 18
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-18 18

RUN apt-get update && apt-get install -y libreadline-dev libgtest-dev libboost-all-dev

# rust
# cspell:disable-next-line
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# python

# user
RUN useradd -m ubuntu

# setup sudo
RUN apt-get update && apt-get install -y sudo
RUN echo "ubuntu:password" | chpasswd
RUN usermod -aG sudo ubuntu

USER ubuntu

WORKDIR /home/ubuntu

CMD ["/bin/bash"]
