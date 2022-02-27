# Postgresql-base

Base to start a new postgresql-database project. This is the start file for your documentation. Instructions how to use this project can be found from the readme.md in the root of the repository directory.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
    bin/
        createdb.sh     # Script to create the database and roles
        dbhelper.sh     # Utility functions to access the database used by createdb.sh
        schemadocs.sh   # Script that createas database docs - only from the public schema
        codedocs.sh     # Script to run Doxygen
        mkdocs.sh       # Script to run mkdocs.sh
    doc/                # Target directory for mkdocs
        code            # Build / initial destination directory for doxygen documentation
        schemadocs      # Build / initial destination directory for schemaspy
    .gitignore          # Files and directories not to be versioned
    Makefile            # Instructions for make
    params_example.sh   # Configurable variables
    Doxyfile            # Doxygen configuration file
