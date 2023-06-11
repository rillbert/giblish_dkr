#!/bin/bash
# helper script to run giblish with pre-defined flags and directories
#
# this script is run automatically when running the docker image.

FLAGS=""

if [[ -f "/styling/gibopts.txt" ]]; then
  FLAGS="${FLAGS} -r /styling $(cat /styling/gibopts.txt)"
fi

echo "converting markdown files to asciidoc..."
# convert markdown to asciidoc
find /src -iname "*.md" \
    -type f \
    -exec sh -c \
    'FILENAME={}; kramdoc --format=GFM \
        --wrap=ventilate \
        --output=${FILENAME%md}adoc {}' \;

if [[ -z "${FLAGS}" ]]; then
    echo "running giblish without any flags..."
else
    echo "runnig giblish with the following flags: ${FLAGS} ..."
fi

# generate output from asciidoc files
giblish ${FLAGS} /src /dst
