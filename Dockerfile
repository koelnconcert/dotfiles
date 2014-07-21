FROM ubuntu:14.04
MAINTAINER Sebastian Peters <koelnconcert@googlemail.com>

# install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y htop
RUN apt-get install -y vim
RUN apt-get install -y man-db
RUN apt-get install -y mbuffer
RUN apt-get install -y dnsutils
RUN apt-get install -y jq
RUN apt-get install -y xml2

# base config
RUN echo "ALL	ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN locale-gen de_DE.UTF-8
ENV LC_ALL de_DE.UTF-8

# create dev user
RUN useradd dev
RUN mkdir /home/dev
RUN chown -R dev: /home/dev
WORKDIR /home/dev
ENV HOME /home/dev
USER dev

# install homeshick and dotfiles
RUN wget https://raw.github.com/koelnconcert/dotfiles/master/install.sh
RUN bash install.sh
RUN rm -f install.sh

# config dev user
RUN sed -i -e '/^LP_HOSTNAME_ALWAYS=/ s/=0/=1/' .liquidpromptrc

# start with shell
CMD bash


