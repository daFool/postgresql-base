#!/bin/bash
## @file bin/createdb.sh
## @brief Creates the new database with roles
## Readds params.sh file and creates named database with two user roles and one group role.
## Sets permissions and passwords for these roles. Uses bin/dbhelper.sh for database access functions.
## @see psqlexecute
## @see psqlaexecute
## @see psqlfile
DDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
DDIR=${DDIR%/bin}
PARAMS=$DDIR/params.sh
source $PARAMS
source $DDIR/bin/dbhelper.sh

SQLBASE=$DDIR/sql

## @fn createdbuser()
## Creates a database user if one doesn't already exist
## @arg $1 string username to create
## @return 0 if creation succeeded
## @return 1 if creation failed
createdbuser() {
    if [ $# -ne 1 ]; then
        echo "Missing username to create ($#) $1"
        return 1
    fi
    psqlexecute "select usename from pg_catalog.pg_user where usename='$1'" || return 1
    if [ "$res" != "$1" ]; then
        createuser $1;
        if [ $? -ne 0 ]; then
            echo "Creation of user $1 failed"
            return 1
        fi
    fi
}

psqlaexecute "select datname from pg_catalog.pg_database where datname='$DATABASE'" || { echo "Unable to list databases" && exit 1; }
if [ "$res" != "$DATABASE" ]; then       
    createdb -E "UTF-8" $DATABASE
    if [ $? -ne 0 ]; then
        echo "Creation of database: $DATABASE failed."
        exit 1
    fi
fi


createdbuser $DBUSER || exit 1
psqlexecute "alter user $DBUSER with encrypted password '$DBPASSWORD'" || exit 1
createdbuser $DBREPORTUSER || exit 1
psqlexecute "alter user $DBREPORTUSER with encrypted password '$DBREPORTUSERPASSWORD'" || exit 1
for i in schemas tables sequences functions types; do
    psqlexecute "alter default privileges grant all on $i to $DBUSER" || exit 1
done
for i in tables sequences; do
    psqlexecute "alter default privileges grant select on $i to $DBREPORTUSER" || exit 1
done
psqlexecute "alter default privileges grant usage on types to $DBREPORTUSER" || exit 1
psqlexecute "alter default privileges grant execute on functions to $DBREPORTUSER" || exit 1   
psqlexecute "select groname from pg_catalog.pg_group where groname='$MATVIEWGROUP'" || exit 1
if [ "$res" != "$MATVIEWGROUP" ]; then
    psqlexecute "create role $MATVIEWGROUP NOLOGIN" || exit 1
    psqlexecute "alter group $MATVIEWGROUP add user $DBUSER" || exit 1
fi

psqlfile $SQLBASE/templates/_base.sql

