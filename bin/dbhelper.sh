#!/bin/bash
## @file bin/dbhelper.sh
## @brief Helper functions to provide psql executions
## Provides functions to execute sql commands against the new and postgres databases with psql.
## Requires existence of params.sh file for global paramerization.
DDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
DDIR=${DDIR%/bin}
PARAMS=$DDIR/params.sh
source $PARAMS

PSQL="psql -A -d $DATABASE -v ON_ERROR_STOP=on -q -t -h $DBHOST -p $DBPORT"
PSQLA="psql -A -d postgres -v ON_ERROR_STOP=on -q -t -h $DBHOST -p $DBPORT"

## @fn psqlexecute()
## Execute single query/command on the new database
## @param $1 string command to execute
## @return 1 if failed
## @return 0 if succeeded
## \showrefby
psqlexecute() {
    if [ $# -ne 1 ]; then
        echo "What do you want to execute? ($#) $*"
        return 1
    fi

    res=$($PSQL -c "$1")
    if [ $? -ne 0 ]; then
        echo "SQL: $1 Failed"
        return 1
    fi
    return 0
}

## @fn psqlaexecute()
## Execute single query/command on the postgres database
## @param $1 string command to execute
## @return 0 if successfull
## @return 1 if failed
## \showrefby
function psqlaexecute() {
    if [ $# -ne 1 ]; then
        echo "What do you want to execute? ($#) $*"
        return 1
    fi

    res=$($PSQLA -c "$1")
    if [ $? -ne 0 ]; then
        echo "SQL: $1 Failed"
        return 1
    fi
    return 0
}

## @fn psqlfile()
## Execute file of sql-queries/statements on the new database
## @param $1 string filename to execute
## @return 0 if successfull
## @return 1 if failed
## \showrefby
function psqlfile() {
     if [ $# -ne 1 ]; then
        echo "Missing file? ($#) $*"
        return 1
    fi

    res=$($PSQL < $1)
    if [ $? -ne 0 ]; then
        echo "SQL: Execution of file $1 Failed"
        return 1
    fi
    return 0
}