#!/bin/bash
set -e
set -x

# Input / Source dir
BUILD_DIR=${BUILD_DIR:=$(mktemp -d)}
CLEAN_BUILD_DIR=${CLEAN_BUILD_DIR:-0}

# pre build commands
PRE_BUILD_CMD=${PRE_BUILD_CMD:-true}
PRE_BUILD_ARGS=${PRE_BUILD_ARGS:-true}

# post build commands
POST_BUILD_CMD=${POST_BUILD_CMD:-true}
POST_BUILD_ARGS=${POST_BUILD_ARGS:-true}

# GIT_REPO & branch can also be assigned using CMD:
GIT_BRANCH=${GIT_BRANCH:-master}

[ "${CLEAN_BUILD_DIR}" != "0" ] && rm -rf --one-file-system ${BUILD_DIR} && mkdir -p ${BUILD_DIR}

# Build using git repo
if [ ! -z "${GIT_REPO}" ] ; then
	git clone -b ${GIT_BRANCH} "${GIT_REPO}" $BUILD_DIR
fi

# Build process
cd "$BUILD_DIR"
${PRE_BUILD_CMD} ${PRE_BUILD_ARGS}
if [ -z "${BUILD_CMD}" ] ; then
	make
	make package
else
	${BUILD_CMD} ${BUILD_ARGS}
fi
${POST_BUILD_CMD} ${POST_BUILD_ARGS}

exit 0
