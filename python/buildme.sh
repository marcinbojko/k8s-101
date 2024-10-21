#!/bin/bash
release=$(grep -i "LABEL RELEASE" Dockerfile|awk '{print $2}'|cut -d\" -f2)
version=$(grep -i "LABEL VERSION" Dockerfile|awk '{print $2}'|cut -d\" -f2)
maintainer=$(grep -i "LABEL MAINTAINER" Dockerfile|awk '{print $2}'|cut -d\" -f2)
coverage="./.coverage.txt"
echo Version: "$version" found
echo Release: "$release" found
echo Maintainer: "$maintainer" found
if [ -n "$version" ] && [ -n "$release" ]; then
  docker buildx build --platform linux/amd64 --pull -t "$release":"$version" .
  build_status=$?
  docker container prune --force
  # let's tag latest
  docker tag "$release":"$version" "$release":latest
else
  echo "No version or release found, exiting"
  exit 1
fi
# coverage
if [ "$build_status" == 0 ]; then
  echo "Docker build succeed"
  rm -rf dive.log||true
  rm -rf ./.*.txt||true
  date > "$coverage"
  echo "Checking versions"
else
 echo "Docker build failed, exiting now"
fi
if [ -n "$version" ] && [ -n "$release" ] && [ -n "$maintainer" ]; then
  echo Version: "$version" found
  echo Release: "$release" found
  echo maintainer: "$maintainer" found
  docker login
  docker tag "$release:$version" "$maintainer/$release:$version"
  docker tag "$release:$version" "$maintainer/$release:latest"
  docker push "$maintainer/$release:$version"
  docker push "$maintainer/$release:latest"
else
 echo Version or Release or Maintainer tag is empty
 exit 1
fi