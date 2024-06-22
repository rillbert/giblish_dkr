#!/bin/bash
# helper script to run giblish with pre-defined options
# and directories
#
# this script is run automatically when running the docker image.

OPTS=""

echo ""
echo "== Run the entrypoint script in the container... =="
echo ""

# find giblish options in these locations
# 1. /src/gibopts.txt
# 2. /styling/gibopts.txt
if [[ -f "/src/gibopts.txt" ]]; then
    GIBOPTS_FILE="/src/gibopts.txt"
elif [[ -f "/styling/gibopts.txt" ]]; then
    GIBOPTS_FILE="/styling/gibopts.txt"
fi
OPTS=$(cat ${GIBOPTS_FILE} 2>/dev/null)

# setup the directory containing the layout assets
if [[ -d "/styling" ]]; then
    OPTS="${OPTS} -r /styling"
fi

# convert markdown to asciidoc if the --convert-md is set
# the OPTS variable.
if [[ "${OPTS}" == *"--convert-md"* ]]; then
    echo "- found the --convert-md flag in the options,"
    echo "  will convert markdown files to asciidoc before"
    echo "  generating the output."

    # convert markdown to asciidoc
    find /src -iname "*.md" \
        -type f \
        -exec sh -c \
        'FILENAME={}; kramdoc --format=GFM \
            --wrap=ventilate \
            --output=${FILENAME%md}adoc {}' \;

    # remove the --convert-md flag from the OPTS variable
    OPTS=$(echo ${OPTS} | sed 's/--convert-md//')
fi

GIBLISH_VERSION_STR=$(giblish --version)

# if the GIBOPTS_FILE is found, notify user of the
# location of the file
if [[ -n "${GIBOPTS_FILE}" ]]; then
    echo "- found giblish options in ${GIBOPTS_FILE}"
fi

if [[ -z "${OPTS}" ]]; then
    echo "- running ${GIBLISH_VERSION_STR} without any options..."
else
    echo "- running ${GIBLISH_VERSION_STR} with the following options:"
    echo "  ${OPTS} ..."
fi
echo ""
echo "conversion log:"
echo "----------------"

# generate output from asciidoc files
giblish ${OPTS} /src /dst
