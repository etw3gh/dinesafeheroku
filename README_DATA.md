### Data sources

Restaurant inspections are made available once or twice a month as a zipped XML archive.

Geographic data is available as a zipped group of shapefiles.

Since Dinesafe data is restricted to the city of Toronto we can use the shapefiles to get geolocation data without Google Maps.

### Local server role

Data is acquired and processed locally.

The posgres database is then pushed to heroku.

User data is not hosted on heroku and exists on a local mongodb server.

## Data Storage

Shapefiles are converted to json by an existing python script

the `downloads` directory is local only and not pushed to heroku or github

Downloads dir structure:

<!-- language: lang-none -->
    downloads/
    ├── dinesafe
    │   ├── xml
    │   │   ├── 1483469307_dinesafe.xml
    │   │   ├── 1484577503_dinesafe.xml
    │   │   ├── 1486579098_dinesafe.xml
    │   │   ├── 1487001084_dinesafe.xml
    │   │   ├── 1488832096_dinesafe.xml
    │   │   ├── 1490721006_dinesafe.xml
    │   │   ├── 1491832647_dinesafe.xml
    │   │   └── 1493045091_dinesafe.xml
    │   └── zip
    │       └── 1493045091_dinesafe.zip
    └── geo
        ├── json
        │   ├── 1474461890_geo.json
        │   ├── 1491231264_geo.json
        │   └── dupe_1491231264_geo.json
        ├── shp
        │   └── 1491231264
        │       ├── ADDRESS_POINT_WGS84.dbf
        │       ├── ADDRESS_POINT_WGS84.prj
        │       ├── ADDRESS_POINT_WGS84_readme.txt
        │       ├── ADDRESS_POINT_WGS84.shp
        │       ├── ADDRESS_POINT_WGS84.shp.xml
        │       ├── ADDRESS_POINT_WGS84.shx
        │       └── readme_address_points_Jan2013.txt
        └── zip
            └── 1491231264_address_points_wgs84.zip

### Data Acquisiton tasks

    rake sched:dl

> Scheduled downloads from city server

> Rufus scheduler used to run daily

> See config/initializers/cron_tasks/sched_toronto.rb 

> LatestDownload model is a singleton instance

> Keeps track of last-modified headers for geo and xml data

> Keeps an md5 hash of each file

> Reset this model with `rake sched:resetdl`

> Extract the xml to downloads/dinesafe/xml 

> Filename is timestamped

    rake unzip:xml

> Extract the shapefile archive to a timestamped folder

> downloads/geo/shp/[TIMESTAMP]/....

    rake unzip:geo

#### Log File Samle Entry

<!-- language: lang-none -->


    ----------------
    Current Time is 2017-06-07 12:41:23 -0400 / 1496853683
    ld_lastmod_xml: 1496065999
    ld_lastmod_geo: 1491231264
    xml_last_mod: 1496065999
    shape_last_mod: 1491231264
    Current LatestDownload instance:
    -lastmodxml: 1496065999
    -lastmodgeo: 1491231264
    -md5xml: 3db88d4bb57123219e05dcba1c6c8a1a
    -md5geo: 75979c7d11321ec0695cf910b94ef408
    SCHEDULED DL OUTCOME:
    xml file NOT downloaded
    geo file NOT downloaded
    ----------------

### Data Processing tasks

> Convert a shapefile archive to json

> Uses a legacy python script, called from rake

    rake jsonify:geo

> Interactive menu of archives with option to do all. Useful if processing is interrupted

> Reads xml or json files, writes data to various models as required

    rake get:menu

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

### Results

Keeping all historical inspections as long as it remains under 10 Million rows

<!-- language: lang-none -->

    from `rails c` or `heroku run rails c`

    Inspection.all.group(:version).count

    => {1488832096=>86772, 1483469307=>85638, 1487001084=>86555, 1484577503=>86712, 1486579098=>86253}

### Verify Venues

Verify no inspection has a non-existant venue

    rake ver:venues