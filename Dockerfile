############################################################
# Dockerfile to build fpm-build images
# fpm can be used to build .rpm or .deb packages
# Based on Debian
# See: https://fpm.readthedocs.io
############################################################
FROM debian:buster-slim

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
	&& apt-get clean && \
	gem install --no-ri --no-rdoc fpm && \
	rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

COPY build.sh /build.sh
CMD /build.sh
