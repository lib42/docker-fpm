# Container-Image for fpm
## Overview
This Docker-Image includes "fpm" [[1]](https://fpm.readthedocs.io/en/latest/) (Not to be confuse with php-fpm [[2]](https://php-fpm.org/)!). fpm is used to build Linux Packages like .deb (Debian/Ubuntu/...) or .rpm (Redhat/CentOS/...). This container comes with a basic fpm install, build-essential and git. 

It allows building directly from a git repository, using "make" by default.

## Usage
Here is a basic example from the [fpm-documentation](https://fpm.readthedocs.io/en/latest/use-cases/files.html), that will build a deb-package containing jenkins.

```
NAME=jenkins
VERSION=2.80

wget https://updates.jenkins-ci.org/download/war/$(VERSION)/jenkins.war
fpm -s dir -t deb -n $(NAME) -v $(VERSION) --prefix /opt/jenkins jenkins.war
```

```
docker run -v $(pwd)/build:/build lib42/fpm 
```

Now fpm will build our package using "make package" command inside of the build-directory.
The output will show something like this if it succeedes:
```
...
fpm -s dir -t deb -n jenkins -v 2.80 --prefix /opt/jenkins jenkins.war
...
{:timestamp=>"2017-11-03T10:01:34.509101+0000", :message=>"Created package", :path=>"jenkins_2.80_amd64.deb"}
```
