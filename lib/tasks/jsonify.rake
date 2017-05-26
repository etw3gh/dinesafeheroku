# first unzip: rake unzip:geo
# with the timestamp of the containing directory, call the rake task

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