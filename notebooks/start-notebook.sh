#!/bin/bash

set -e

if [[ -n "$JUPYTER_NOTEBOOK_TOKEN" ]]; then
  token="--NotebookApp.token=$JUPYTER_NOTEBOOK_TOKEN"
fi

. /usr/local/bin/start.sh jupyter notebook $token $*
