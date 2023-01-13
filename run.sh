#!/bin/bash

FLAGS=""

if [[ -d "layout" ]]; then
  FLAGS="${FLAGS} -r layout -s giblish"
fi

if [[ -f "layout/gibopts.txt" ]]; then
  FLAGS="${FLAGS} $(cat layout/gibopts.txt)"
fi

if [[ -z "${FLAGS}" ]]; then
    echo "running giblish without any flags..."
else
    echo "runnig giblish with the following flags: ${FLAGS} ..."
fi

giblish ${FLAGS} src dst
