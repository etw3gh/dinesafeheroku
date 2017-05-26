## why

originally there was a python web service that managed the xml and shapefiles

shaperip.py was a standalone script that converted a group of shapefiles to a single json file

we're using it here and may call it from a rake task eventually

### usage

first, extract the shapefiles

    rake unzip:geo

then, plug in the timestamp dir as a python arg (1491231264 in this case)


### call from rake task

    rake jsonify:geo[1491231264]

### call from CLI (python)

    python3 python/shaperip.py downloads/geo/shp/1491231264/ADDRESS_POINT_WGS84.dbf downloads/geo/json

### requirements

from python directory:

    pip3 install -r requirements.txt


### Directory Structure

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