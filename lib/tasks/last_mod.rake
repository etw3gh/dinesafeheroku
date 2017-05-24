require_relative('../dinesafe/downloader')
require_relative('../acquisitions')

namespace :header do

  desc "get last mod for xml and geo"
  task :lastmods => :environment do
    d = Acquisitions.instance.dinesafe
    s = Acquisitions.instance.shapefiles
    puts 
    puts 
    xml_dl = Downloader.new(d[:url])
    shape_dl = Downloader.new(s[:url])
    puts "#{d[:url]}: #{xml_dl.header['last-modified']}"
    puts '------'
    puts "#{s[:url]}: #{shape_dl.header['last-modified']}"
  end

end