namespace :jsonify do
  geo_acq = Acquisitions.instance.shapefiles

  @geo_txt = geo_acq[:textfiles]
  @geo_zip = geo_acq[:archives]
  @geo_shp = geo_acq[:shapefiles]
  @geo_fn  = geo_acq[:filename]

  # usage: rake jsonify:geo [timestamp]
  task :geo, [:timestamp] => :environment do |t, args|
    if args.timestamp.nil?
      puts 'missing arg'
    else
      source = '{}{}/{}'.format(@geo_shp, args.timestamp, @geo_fn)
      py = 'python3 ../../python/shaperip.py {} {}'.format(source, @geo_txt)
      system(py)
    end
  end
end