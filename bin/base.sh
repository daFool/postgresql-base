#!/bin/bash
## @file bin/base.sh
## @brief Template for building future bash-scripts
## Mantra to figure out "our" root directory and source configurable variables.
DDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
DDIR=${DDIR%/bin}
PARAMS=$DDIR/params.sh
source $PARAMS