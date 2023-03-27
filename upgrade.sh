#!/bin/bash

# exit if script fails
set -e

new_version=$1

echo "Upgrading to version $new_version"

# download new version
docker tag nginx:latest memobre/nginx:$new_version
docker push memobre/nginx:$new_version

# create a temporary directory
tmp_dir=$(mktemp -d)
echo "Created temporary directory $tmp_dir"

git clone https://github.com/lengebre/test-image-build.git $tmp_dir

# update the version in the Dockerfile
sed -i "s/memobre\/nginx:.*/memobre\/nginx:$new_version/g" $tmp_dir/deploy/1-deploy.yml

cd $tmp_dir
git add .
git commit -m "Upgrade to version $new_version"
git push