### usage

first, extract the shapefiles

    rake unzip:geo

then, plug in the timestamp dir as a python arg (1491231264 in this case)

### TODO

rake task to call the python script


from rails root:

    python3 python/shaperip.py downloads/geo/shp/1491231264/ADDRESS_POINT_WGS84.dbf downloads/geo/json
