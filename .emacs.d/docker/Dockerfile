FROM ubuntu:22.04

ARG CLANG_VERSION=19

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

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${CLANG_VERSION} ${CLANG_VERSION}
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-${CLANG_VERSION} ${CLANG_VERSION}
RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-${CLANG_VERSION} ${CLANG_VERSION}
RUN update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-${CLANG_VERSION} ${CLANG_VERSION}
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-${CLANG_VERSION} ${CLANG_VERSION}

RUN apt-get update && apt-get install -y libreadline-dev libgtest-dev libboost-all-dev

# NOTE: apt-get install cmake causes following error
# The following packages have unmet dependencies:
#  emacs-pgtk : Breaks: dh-elpa-helper (< 2.1.7) but 2.0.9ubuntu1 is to be installed
# E: Error, pkgProblemResolver::Resolve generated breaks, this may be caused by held packages.
# so install latest cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - > /usr/share/keyrings/kitware-archive-keyring.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' > /etc/apt/sources.list.d/kitware.list
RUN apt-get update && apt-get install -y cmake

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
