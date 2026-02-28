FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive # cspell:disable-line

RUN apt-get update

RUN apt-get install -y tzdata

RUN apt-get install -y ubuntu-desktop

RUN apt-get install -y curl git ripgrep

RUN add-apt-repository ppa:ubuntuhandbook1/emacs && \ # cspell:disable-line
    apt-get update

RUN apt-get install -y emacs # emacs30 as of 2026/02/28

RUN useradd -m ubuntu

USER ubuntu

WORKDIR /home/ubuntu

CMD ["/bin/bash"]
