#!/bin/bash

set -e

if [[ -n "$JUPYTER_NOTEBOOK_TOKEN" ]]; then
  token="--NotebookApp.token=$JUPYTER_NOTEBOOK_TOKEN"
fi

if [[ -n "$JUPYTER_ENABLE_LAB" ]]; then
  . /usr/local/bin/start.sh jupyter lab $token $*
else
  . /usr/local/bin/start.sh jupyter notebook $token $*
fi
