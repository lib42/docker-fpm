############################################################
# Dockerfile to build fpm-build-base images
# fpm can be used to build .rpm or .deb packages
# Based on Debian
# See: https://fpm.readthedocs.io
############################################################
FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
	apt-get -y --no-install-recommends install \
		ruby \ 
		ruby-dev \
		rubygems \
		build-essential \
		git \
		wget \
		rpm \
		gawk \
	&& apt-get clean
RUN gem install --no-ri --no-rdoc fpm
RUN rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

COPY build.sh /build.sh
ENTRYPOINT /build.sh
