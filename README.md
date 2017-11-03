# Docker-Image fpm-build
## Overview
This Docker-Image includes "fpm" [[1]](https://fpm.readthedocs.io/en/latest/) (Not to be confuse with php-fpm [[2]](https://php-fpm.org/)!). fpm is used to build Linux Packages like .deb (Debian/Ubuntu/...) or .rpm (Redhat/CentOS/...). This container comes with a basic fpm install, build-essential and git. 

It allows building directly from a git repository, using "make" by default.

## Usage
Here is a basic example from the [fpm-documentation](https://fpm.readthedocs.io/en/latest/use-cases/files.html), that will build a deb-package containing jenkins.

*Makefile:*
```
NAME=jenkins
VERSION=2.80

.PHONY: package
package:
	rm -f jenkins.war
	wget https://updates.jenkins-ci.org/download/war/$(VERSION)/jenkins.war
	fpm -s dir -t deb -n $(NAME) -v $(VERSION) --prefix /opt/jenkins jenkins.war
```

We save this file under build/Makefile, and run the container:
```
docker run -e BUILD_DIR=/build -e BUILD_CMD="make package" -v $(pwd)/build:/build nold360/fpm-build
```

Now fpm will build our package using "make package" command inside of the build-directory.
The output will show something like this if it succeedes:
```
...
fpm -s dir -t deb -n jenkins -v 2.80 --prefix /opt/jenkins jenkins.war
...
{:timestamp=>"2017-11-03T10:01:34.509101+0000", :message=>"Created package", :path=>"jenkins_2.80_amd64.deb"}
```

## Environment Variables
### BUILD_DIR
Directory containing the sources, which we want to package. You will most likely want to use a persistent directory from your host for this directory.
**Default:** Random directory in /tmp (mktemp -d)

### BUILD_CMD
Command that's going to be executed to build the package / source.
**Default:** make && make package

### BUILD_ARGS
Arguments for BUILD_CMD
**Default:** *none*

### PRE_BUILD_CMD
Command to be executed *before* BUILD_CMD
**Default:** *none*

### PRE_BUILD_ARGS
Arguments for PRE_BUILD_CMD
**Default:** *none*

### POST_BUILD_CMD
Command to be executed *after* BUILD_CMD
**Default:** *none*

### POST_BUILD_ARGS
Arguments for POST_BUILD_CMD
**Default:** *none*

### CLEAN_BUILD_DIR
Delete everything inside of BUILD_DIR before building. **Everything != 0 will cause a cleanup!**
Only usefull if combined with GIT_REPO & persistent BUILD_DIR.
**Default:** 0

### GIT_REPO
Source Repository to clone from. If GIT_REPO is set, the GIT_REPO will be cloned into $BUILD_DIR.
**Default:** *none* 

### GIT_BRANCH
Branch to clone from GIT_REPO
**Default:** master


## Extending
Since there are lots of different code / programming languages you might want to compile & package, you will want to extend this image to your own needs.

*Example Dockerfile*
```
FROM nold360/fpm-build
RUN apt-get update && apt-get -y install python3
ENTRYPOINT /build.sh
```

Happy hacking!

## Docker-Compose Example
*docker-compose.yml*
```
---
version: '2'
services:
 fpm-build-mksdiso:
  image: nold360/fpm-build
  volumes:
   - ./mksdiso:/build
  environment:
   GIT_REPO: https://github.com/Nold360/mksdiso
   BUILD_DIR: "/build"
```
