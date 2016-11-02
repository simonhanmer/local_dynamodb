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

# Download package
echo -n "Downloading package: "
wget $url -qO ${archive} ${TAR_URL}

if [ $? -gt 1 ]
then
    (>&2 echo "Package download failed")
    exit 1
    rm -f ${archive}
fi

HERE=$(pwd)

echo
echo -n "Extracting archive: "
tar xz --strip-components=1 -C ${DEPLOY_DIR} -f ${archive} 2>/dev/null
if [ $? -gt 1 ]
then
    (>&2 echo "extract failed")
    rm -f ${archive}
    exit 1
fi

rm -f ${archive}
cd ${DEPLOY_DIR}
if [ ! -d ${DEPLOY_DIR}/data ]
then
    mkdir ${DEPLOY_DIR}/data
fi

# Check we have a dynamodb user
echo
echo "Ensure dynamodb user exists"
grep -q dynamodb /etc/passwd
if [ $? -ne 0 ]
then
    useradd dynamodb
fi

chown -R dynamodb.dynamodb ${DEPLOY_DIR}

echo "Setup service"
# Grab files from github
wget --progress=dot -qO /lib/systemd/system/dynamodb-server.service https://raw.githubusercontent.com/simonhanmer/local_dynamodb/master/dynamodb-server.service

systemctl daemon-reload
