#!/bin/bash
## @file bin/codedocs.sh
## @brief Runs doxygen
## Creates doxygen initial target directory if one doesn't exist yet.
DDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
DDIR=${DDIR%/bin}
PARAMS=$DDIR/params.sh
source $PARAMS

if [ ! -d $CODEDOCS ]; then
    mkdir -p $CODEDOCS || { echo "Creation of $CODEDOCS failed!" && exit 1; }
fi
cd $DDIR
doxygen