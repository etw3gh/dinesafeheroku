#!/bin/bash
PGUSER=ds PGPASSWORD=$DINESAFE_DATABASE_PASSWORD heroku pg:push dinesafe_development $DINESAFE_PG_ALIAS --app $DINESAFE_APP_NAME
