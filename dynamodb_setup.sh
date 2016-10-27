#!/bin/bash
#
#    Copyright (C) 2016 Simon Hanmer
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# This script grabs the local dynamodb installer from amazon and uses it to create a local
# install of dynamodb.

TAR_URL=http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz
DEPLOY_DIR=/opt/dynamodb

# Make sure the directory exists
if [ ! -d ${DEPLOY_DIR} ]
then
    mkdir -p ${DEPLOY_DIR}
    if [ $? -ne 0 ]
    then
        (>&2 echo "Can't create deployment directory")
        exit 1
    fi
fi

archive=$(basename ${TAR_URL})

# Download package unless we already have it
echo -n "Downloading package: "
wget --no-clobber $url -O ${archive} ${TAR_URL}

if [ $? -gt 1 ]
then
    (>&2 echo "Package download failed")
    exit 1
fi

HERE=$(pwd)

cd ${DEPLOY_DIR}
tar tzv --strip-components=1 -f ${HERE}/dynamodb_local_latest.tar.gz
