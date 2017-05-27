## Dinesafe backend

### Overview

Dinesafe is a system for restaurant inspections for the city of Toronto

### Docs

path | description |  
--- | ---
./README.md | this file. thank you
./README_DATA.md | data acquisition and processing
./README_MONGO.md | mongo overview
./README_PSQL.md | postgres overview
./README_SECURITY.md | security measures
./python/README_SHAPEFILES.md | desc of legacy python for shapefile scraping 

### DB notes

#### PostgreSQL (Read Only)

Because the dataset is very large and takes a lot of time to process on a local machine,
it is written to Heroku via pgpush, which erases existing data.

See README_PSQL.md for more details.

For this reason it made sense to use another method to store user added data.

#### MongoDB (User Data)

Self hosted on an Ubuntu server.

Using the standard mongo gem.

See README_MONGO.md for more details.


### Local DB and Heroku DB

  Rake tasks are database intensive so heroku pg:push is used to push data from the local psql db instead of writing directly to production

  see README_PSQL.md for more details