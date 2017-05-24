require_relative('../dinesafe/downloader')
require_relative('../acquisitions')

namespace :header do

  desc "get last mod for xml and geo"
  task :lastmods => :environment do
    durl = Acquisitions.instance.dinesafe['url']
    surl = Acquisitions.instance.shapefiles['url']
    puts durl
    puts surl
    xml_dl = Downloader.new(durl)
    shape_dl = Downloader.new(surl)
    puts xml_dl.header
    puts '------'
    puts shape_dl.header
  end

end