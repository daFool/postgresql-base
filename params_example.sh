#!/bin/bash
## \file params_example.sh
## Copy this file to params.sh and change export variables to your liking.
## 
DDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
## \defgroup dbvars Database related variables
## Variables to define database to be created.

## @var string DATABASE 
## name of the database to create
## \ingroup dbvars
export DATABASE="slskirjasto";
## \var string DBUSER
## name of the rw user to create
## \ingroup dbvars 
export DBUSER="sls";
## \var string DBPASSWORD
## password for the rw user
## \ingroup dbvars 
export DBPASSWORD="*";
## \var string DBHOST
## host where the database will be
## \ingroup dbvars 
export DBHOST="localhost";
## \var int DBPORT
## Database port
## \ingroup dbvars
export DBPORT=5432
## \var string DBREPORTUSER 
## name of the r user to create
## \ingroup dbvars
export DBREPORTUSER="slsreport";
## \var string DBREPORTUSERPASSWORD 
## password for the r user
## \ingroup dbvars
export DBREPORTUSERPASSWORD="*"
## \var string MATVIEWGROUP 
## group role to own all created materialized views
## \ingroup dbvars 
export MATVIEWGROUP="slsmaterial"

## \defgroup docvars Documentation related variables 
## Variables that define how documentation should be created
## \var string SCHEMASPY
## Java library for documenting database.
## \ingroup docvars
export SCHEMASPY=/home/mos/javalib/schemaspy-6.1.0.jar
## \var string PGSQLJDBC
## JDBC driver for postgresql used by SCHEMASPY
## \ingroup docvars
export PGSQLJDBC=/opt/DbVisualizer/jdbc/postgresql/postgresql.jar
## \var string SCHEMADOCS
## target directory for generated database docs
## \ingroup docvars
export SCHEMADOCS=${DDIR}/doc/schema
## \var string SCHEMA
## Database schema to be documented
## \ingroup docvars
export SCHEMA=templates
## \var string CODEDOCS
## Target directory from doxygen generated code docs
## \ingroup docvars
export CODEDOCS=${DDIR}/doc/code
## \var string TARGETPROJECT
## Target directory to copy scripts to and prepare
export TARGETPROJECT=/home/mos/authdemo