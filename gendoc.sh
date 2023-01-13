#!/bin/bash

# convenience script for generating documents using the giblish docker image
#
# usage: gendocs.sh [layout_dir] src dst

if [[ $# == "3" ]]; then
  LAYOUT_DIR="$1"
  SRC_DIR="$2"
  DST_DIR="$3"
elif [[ $# == "2" ]]; then
  SRC_DIR="$1"
  DST_DIR="$2"
else
  echo "usage: gendocs.sh [layout_dir] src dst"
  exit
fi

# make sure paths are absolute
SRC_DIR=$(realpath "${SRC_DIR}")
DST_DIR=$(realpath "${DST_DIR}")

if [[ ! -d "${DST_DIR}" ]]; then
  mkdir -p "${DST_DIR}"
fi

MOUNT_FLAGS=(
    "--mount type=bind,src="${SRC_DIR}",dst=/src/" \
    "--mount type=bind,src="${DST_DIR}",dst=/dst/"
)

if [[ "${LAYOUT_DIR}" ]]; then
  LAYOUT_DIR=$(realpath "${LAYOUT_DIR}")
  MOUNT_FLAGS+=("--mount type=bind,src="${LAYOUT_DIR}",dst=/layout/")
fi

docker run \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    --rm \
    ${MOUNT_FLAGS[@]} \
    gibdk:latest