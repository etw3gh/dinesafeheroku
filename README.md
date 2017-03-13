# Dinesafe backend

## Overview

Dinesafe is a system for restaurant inspections for the city of Toronto

### Data sources

Restaurant inspections are made available once or twice a month as a zipped XML archive.

Geographic data is available as a zipped group of shapefiles.

Since Dinesafe data is restricted to the city of Toronto we can use the shapefiles to get geolocation data without Google Maps.

### Python services

A [linux service](https://github.com/openciti/dinesafemicroservices) monitors the city website for new version of the geo and xml data.

The XML data is unzipped and the file is saved with a timestamp in the filename.

The shapefiles are processed and saved in a more useful JSON format.

A [microservice](https://openciti.ca/cgi-bin/ds/all) exposes the timestamped filenames for the rails rake tasks.


### Local DB and Heroku DB

  Rake tasks are database intensive so heroku pg:push is used to push data from the local psql db instead of writing directly to production

  see README_PSQL.md for more details

#### Order of operation for updating and seeding production DB

* `rake get:geo|xml|all`
* `heroku pg:reset -a dinesafe`
* `./localpsql/pgpush.sh`

### Rake tasks (lib/tasks)



#### Get all filenames

Get a list of all archive files. Arrays are sorted in descending order (by timestamp)

    `rake get:filenames`

Interactive menu of archives with option to do all

    `rake get:menu`

<!-- language: lang-none -->

    d@e:~/dinesafe$ rake get:menu
    XML
    1: 1488832096.0_dinesafe.xml, processed: FALSE
    2: 1487001084.0_dinesafe.xml, processed: FALSE
    3: 1486579098.0_dinesafe.xml, processed: FALSE
    4: 1484577503.0_dinesafe.xml, processed: FALSE
    5: 1483469307.0_dinesafe.xml, processed: FALSE

    GEO
    6: 1474461890.0_geo.json, processed: TRUE, count: 522622, start: 2017-03-12 22:37:27, end: 2017-03-12 23:57:21

    7: All XML
    8: ALL GEO
    9: GET EVERYTHING

    q: Quit


Get all (non interactive). Will iterate over filenames and process if required
For use in a cron task

    `rake get:all`

Process only geographic data

    `rake get:geo`

Process only xml data

    `rake get:xml`


-------

##### to reset
`bin/rails db:environment:set RAILS_ENV=development`

`rake db:drop db:create db:migrate`
