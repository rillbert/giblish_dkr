#!/bin/bash

FLAGS=""

if [[ -f "styling/gibopts.txt" ]]; then
  FLAGS="${FLAGS} -r styling $(cat styling/gibopts.txt)"
fi

if [[ -z "${FLAGS}" ]]; then
    echo "running giblish without any flags..."
else
    echo "runnig giblish with the following flags: ${FLAGS} ..."
fi

giblish ${FLAGS} src dst
