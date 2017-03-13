#!/bin/bash
PGUSER=ds PGPASSWORD=$DINESAFE_DATABASE_PASSWORD heroku pg:push dinesafe_development postgresql-opaque-27045 --app dinesafe
