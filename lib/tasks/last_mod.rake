require_relative('../dinesafe/downloader')
require_relative('../acquisitions')

namespace :header do

  desc "get last mod for xml and geo"
  task :lastmods => :environment do
    a = Acquisitions.instance
    xml_dl = Downloader.new(a.dinesafe['url'])
    shape_dl = Downloader.new(a.shapefiles['url'])
    puts xml_dl.header
    puts '------'
    puts shape_dl.header
  end

end