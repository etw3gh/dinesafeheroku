#!/bin/bash
 PGPASSWORD=$DINESAFE_DATABASE_PASSWORD pg_dump -Fc --no-acl --no-owner -h localhost -U ds dinesafe_development > dinesafe_development.dump
