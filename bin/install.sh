#!/bin/bash
## @file bin/install.sh
## @brief Install additional files to the source project
## Copies helper-scripts to the new project and fixes Laravel .env-file if one is found
DDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
DDIR=${DDIR%/bin}
PARAMS=$DDIR/params.sh
source $PARAMS

cd $DDIR

## @fn copyOrFail()
## Copies file to destination or dies.

function copyOrFail() {
    cp $1 $2 || { echo "Unable to copy $1 to $2" && return 1; }
}

if [ ! -d $TARGETPROJECT/bin ]; then
    mkdir $TARGETPROJECT/bin || { echo "Creating $TARGETPROJECT/bin failed" && exit 1; }
fi

for i in base.sh codedocs.sh createdb.sh dbhelper.sh mkdocs.sh schemadoc.sh; do
    copyOrFail bin/$i $TARGETPROJECT/bin || exit 1
done

for i in Doxyfile Makefile mkdocs.yml params.sh; do
    copyOrFail $i $TARGETPROJECT || exit 1
done

if [ ! -f $TARGETPROJECT/.gitignore ]; then
    copyOrFail .gitignore $TARGETPROJECT || exit 1
else
    cat .gitignore >> $TARGETPROJECT/.gitignore || { echo "Appending to .gitignore failed" && exit 1; }
fi

if [ -f $TARGETPROJECT/.env ]; then
    sed  -e "{ 
        s/^\(DB_CONNECTION\).*/\1=pgsql/;
        s/^\(DB_HOST\).*/\1=$DBHOST/;
        s/^\(DB_PORT\).*/\1=$DBPORT/;
        s/^\(DB_DATABASE\).*/\1=$DATABASE/;
        s/^\(DB_USERNAME\).*/\1=$DBUSER/;
        s/^\(DB_PASSWORD\).*/\1=$DBPASSWORD/;
     }" $TARGETPROJECT/.env -i
    if [ $? -ne 0 ]; then
        echo "Fixing Laravel .env failed"
        exit 1
    fi
fi

for i in sql sql/tables sql/views sql/functions sql/procedures; do
    if [ ! -d $TARGETPROJECT/$i ]; then
        mkdir $1 || { echo "Making directory $i failed" && exit 1; }
    fi
done
