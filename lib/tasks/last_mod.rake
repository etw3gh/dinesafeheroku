require_relative('../dinesafe/downloader')
require_relative('../acquisitions')


namespace :header do

  desc "get last mod for xml and geo"
  task :lastmods => :environment do
    d = Acquisitions.instance.dinesafe
    s = Acquisitions.instance.shapefiles

    xml_dl = Downloader.new(d[:url])
    shape_dl = Downloader.new(s[:url])
    puts "#{d[:url]}: #{xml_dl.last_mod}"
    puts '------'
    puts "#{s[:url]}: #{shape_dl.last_mod}"
  end

  # test method. delete TODO
  task :dl => :environment do
    d = Acquisitions.instance.dinesafe
    fp = "#{d[:path]}/zip/#{d[:filename]}"
    xml_dl = Downloader.new(d[:url])
    xml_dl.dl(fp)
  end
end
