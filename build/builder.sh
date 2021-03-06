#!/bin/bash

set -eu

image="cockroachdb/builder"

function init() {
  docker build --tag="${image}" "$(dirname $0)"
}

if [ "${1-}" = "pull" ]; then
  docker pull "${image}"
  exit 0
fi

if [ "${1-}" = "init" ]; then
  init
  exit 0
fi

if [ "${1-}" = "push" ]; then
  init
  tag="$(date +%Y%m%d-%H%M%S)"
  docker tag "${image}" "${image}:${tag}"
  docker push "${image}"
  exit 0
fi

gopath0="${GOPATH%%:*}"

if [ "${CIRCLECI-}" = "true" ]; then
  # HACK: Removal of docker containers fails on circleci with the
  # error: "Driver btrfs failed to remove root filesystem". So if
  # we're running on circleci, just leave the containers around.
  rm=""
else
  rm="--rm"
fi

if [ -t 0 ]; then
  tty="--tty"
fi

buildcache_dir="buildcache"
uicache_dir="uicache"

# Run our build container with a set of volumes mounted that will
# allow the container to store persistent build data on the host
# computer.
# -i causes some commands (including `git diff`) to attempt to use
# a pager, so we override $PAGER to disable.
docker run -i ${tty-} ${rm} \
  --volume="${gopath0}:/go" \
  --volume="${HOME}/${buildcache_dir}:/${buildcache_dir}" \
  --volume="${HOME}/${uicache_dir}:/${uicache_dir}" \
  --volume="${PWD}:/go/src/github.com/cockroachdb/cockroach" \
  --workdir="/go/src/github.com/cockroachdb/cockroach" \
  --env="CACHE=/${buildcache_dir}" \
  --env="PAGER=cat" \
  "${image}" "$@"
