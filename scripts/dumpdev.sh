#!/bin/bash
PGPASSWORD=$DINESAFE_DATABASE_PASSWORD pg_dump -Fc --no-acl --no-owner -h localhost -U ds dinesafe_development > "/media/raid/raa/`date '+%s'`_dsdev.dump"
