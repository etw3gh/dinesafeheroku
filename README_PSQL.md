# PSQL heroku

## Overview

Inspection and geograhic data is processed locally then pushed to heroku.

## Order of operations

### update local data

    `rake get:all` or `rake get:menu` for interactive archive processing

### reset heroku database

    `heroku pg:reset -a dinesafe`

### push to heroku by script

    `./localpsql/pgpush.sh`

### ENV variables

    $DINESAFE_DATABASE_PASSWORD should be defined in ~/.bashrc
