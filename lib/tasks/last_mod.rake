require_relative('../dinesafe/downloader')
require_relative('../acquisitions')

namespace :header do

  desc "get last mod for xml and geo"
  task :lastmods => :environment do
    d = Acquisitions.instance.dinesafe
    s = Acquisitions.instance.shapefiles
    puts d[:url]
    puts s[:url]
    #xml_dl = Downloader.new(durl)
    #shape_dl = Downloader.new(surl)
    #puts xml_dl.header
    #puts '------'
    #puts shape_dl.header
  end

end