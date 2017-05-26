require_relative('../dinesafe/downloader')
require_relative('../acquisitions')

namespace :sched do

  xml_acq = Acquisitions.instance.dinesafe
  geo_acq = Acquisitions.instance.shapefiles

  @xml_txt = xml_acq[:textfiles]
  @xml_zip = xml_acq[:archives]
  @xml_url = xml_acq[:url]

  @geo_txt = geo_acq[:textfiles]
  @geo_zip = geo_acq[:archives]
  @geo_url = geo_acq[:url]

  task :dl => :environment do
    xml_dl = Downloader.new(@xml_url)
    shape_dl = Downloader.new(@geo_url)
    ld = LatestDownload.instance
    puts ld
    puts ld.blank?
    puts ld.nil?
  end
end