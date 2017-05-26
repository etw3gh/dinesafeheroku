# first unzip: rake unzip:geo
# with the timestamp of the containing directory, call the rake task
"""
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
"""
namespace :jsonify do
  geo_acq = Acquisitions.instance.shapefiles

  @geo_txt = geo_acq[:textfiles]
  @geo_shp = geo_acq[:shapefiles]
  @geo_fn  = geo_acq[:filename]

  # usage: rake jsonify:geo [timestamp]
  desc "converts a collection of shapefiles into a single json file"
  task :geo, [:timestamp] => :environment do |t, args|
    if args.timestamp.nil?
      puts 'missing arg'
    else
      source = "#{@geo_shp}#{args.timestamp}/#{@geo_fn}"
      py = "python3 python/shaperip.py #{source} #{@geo_txt}"
      system(py)
    end
  end
end