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

### Rake tasks (lib/tasks)

#### Get all filenames

Get a list of all archive files. Arrays are sorted in descending order (by timestamp)

    `rake get:all`

#### Process geo data

Process the geographic data first.

This data changes infrequently but its still versioned by timestamp.

TODO: determine what to do upon getting a new version

    `rake process:geo`

Will check timestamp against the Archive model to see if it needs processing.

If so, it will populate the Address model and update the Archive model.
    
#### Process xml data

    `rake process:xml`

Will check timestamp against the Archive model to see if it needs processing.

If so, it will populate the Venue and Inspection models linking to Address as well as updating the Archive model.

#### Refactor

No longer downloading files (for Heroku), but processing them in memory on the heroku instance.



-------

##### to reset
`bin/rails db:environment:set RAILS_ENV=development`

`rake db:drop db:create db:migrate`

