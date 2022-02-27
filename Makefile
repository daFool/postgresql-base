include params.sh

all: database docs install

database:
	bin/createdb.sh

docs: projectdocs codedocs schemadocs
	
schemadocs:	
	bin/schemadoc.sh
	
codedocs:
	bin/codedocs.sh

projectdocs:
	bin/mkdocs.sh

dropdb:
	dropdb ${DATABASE}
	dropuser ${DBUSER}
	dropuser ${DBREPORTUSER}

install:
	bin/install.sh