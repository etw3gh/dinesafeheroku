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