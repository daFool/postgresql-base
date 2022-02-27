# Postgresql-base
This is something I use to startup a new (Laravel) project which uses Postgresql database as backend. You should have a postgresql database server installed somewhere and you are supposed to have enough rights with your running user to create databases and datase users. That means in practice that you are a super user for the database. If you are using database hosted on a different server or otherwise need a password to access the database from command line then you should export some environment variables:

| VARIABLE | PURPOSE | EXAMPLE |
|----------|---------|---------|
| PGUSER   | User to run the psql-command with | mos |
| PGPASSWORD | Password for that user | * |

This project also assumes that your pg_hba.conf has been configured to allow access and php-pgsql module is installed for Laravel to be able to function with postgresql-database. I will address pg_hba.conf and MD5 vs cram-sha-256 authentication later on this page. 

I use three documentation tools to document my code:
* [Doxygen](https://www.doxygen.nl/index.html) with [Bash-filter](https://github.com/Anvil/bash-doxygen)
* [Mkdocs](https://www.mkdocs.org/) for general descriptive documentation and
* [SchemaSpy](https://schemaspy.readthedocs.io/en/latest/index.html) for database schema documentation.

When the project in question is a Laravel php-project then I also use [Postgresql enchantments](https://github.com/tpetry/laravel-postgresql-enhanced). Why use a real database and not have everything it has to offer?

What this project does is to create a new UTF-8 encoded database owned by your user having two users: 
1. a _read user_ who can read everything but can't modify anything and
2. a _read_write_user_ who can do almost anything.

Also a group role who should own all materialized views you create is created and the _read_write_user_ is added to this group. 

All default privileges are set so that excluding materialized views you don't need to **grant** anything to the _read_ or _readwrite_ user. 

A _templates_ schema is created with two template tables. The templates._base table is meant to be template for all database tables that I create and the templates._logbase table is something I frequently use as log-target.

### Laravel
I only use _migrations_ with Laravel base- and extension tables, all other tables and views I create with create scripts. This gives me better control and allows me to use the templates and add documentation for them to be later extracted by Schemaspy. 

There is a nuisance of "-character as Eloquent is designed to replace `-character required by mysql/mariadb and sibling database with it. This works relatively well when you are using migrations as all views you create with them will have the " in the actual name of the view as first and last characters of the name. So, when I create views by hand which I want Eloquent query-builder to understand I will _break_ the view naming with starting and ending "-characters.

## Usage
Install the document tools mentioned earlier - if you wish to use them. You also need bash, sed and make.

All configurable variables are defined in params_example.sh which you should copy to params.sh : `cp params_example.sh params.sh`

`make all` which is the default target creates database, builds documentation and copies template files to your target project

`make docs` build documentation

`make database` builds database

`make install` install template files, fixes Laravel .env if one is found and creates some directories to the project.

## Postgresql access 
The newer versions of Postgresql use cram-sha-256 for authentication by default. This causes problems when you are using older php-pgsql extensions which are compiled against older versions of postgresql-libraries. If you run into access denied errors then you can defautl your postgresql to use md5 for authentication instead. 

This requires that you modify postgresql.conf:
`password_encryption = md5`
and restart the server. 

You should also modify pg_hba.conf to use md5 instead of cram-sha-256. For example if you are using "localhost" you could have following lines at quite start of your pg_hba.conf

    host    all             all             127.0.0.1/32            md5
    host    all             all             ::1/128                 md5
