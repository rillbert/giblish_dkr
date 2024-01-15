#!/bin/bash
# helper script to run giblish with pre-defined flags and directories
#
# this script is run automatically when running the docker image.

FLAGS=""

if [[ -f "/styling/gibopts.txt" ]]; then
  FLAGS="${FLAGS} -r /styling $(cat /styling/gibopts.txt)"
fi

echo "converting eventual markdown files to asciidoc..."
# convert markdown to asciidoc
find /src -iname "*.md" \
    -type f \
    -exec sh -c \
    'FILENAME={}; kramdoc --format=GFM \
        --heading-offset=1 \
        --wrap=ventilate \
        --output=${FILENAME%md}adoc {}' \;

GIBLISH_VERSION_STR=$(giblish --version)

if [[ -z "${FLAGS}" ]]; then
    echo "running ${GIBLISH_VERSION_STR} without any flags..."
else
    echo "runnig ${GIBLISH_VERSION_STR} with the following flags: ${FLAGS} ..."
fi

# generate output from asciidoc files
giblish ${FLAGS} /src /dst
