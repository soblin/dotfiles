# syntax=docker/dockerfile:1
FROM ubuntu:24.04

# /* cspell:disable-next-line */
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y tzdata ubuntu-desktop git curl wget lsb-release software-properties-common ripgrep

# cspell:disable-next-line
RUN add-apt-repository ppa:ubuntuhandbook1/emacs -y && \
    apt-get update

# emacs30 as of 2026/02/28
RUN apt-get install -y emacs
