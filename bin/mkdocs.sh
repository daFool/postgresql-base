#!/bin/bash
## @file bin/mkdocs.sh
## @brief Script to build mkdocs
## Runs mkdocs
DDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
DDIR=${DDIR%/bin}
PARAMS=$DDIR/params.sh
source $PARAMS

if [ ! -d $DOC ]; then
    mkdir $DOC || ( echo "Creation of $DOC failed" && exit 1 )
fi
cd $DDIR
mkdocs build