#!/bin/bash
## @file bin/schemadoc.sh
## @brief Createas database schema documentation
## Runs Schema Spy against the new database.
DDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
DDIR=${DDIR%/bin}
PARAMS=$DDIR/params.sh
source $PARAMS

if [ ! -d $SCHEMADOCS ]; then
    mkdir -p $SCHEMADOCS || (echo "Failed to create $SCHEMADOCS" && exit 1)
fi

java -jar $SCHEMASPY -t pgsql11 -db $DATABASE -o $SCHEMADOCS -s $SCHEMA -u $DBUSER -host $DBHOST  -port $DBPORT -p $DBPASSWORD -dp $PGSQLJDBC -vizjs

if [ $? -ne 0 ]; then
    echo "Schemaspy $SCHEMASPY failed"
    exit 1
fi
