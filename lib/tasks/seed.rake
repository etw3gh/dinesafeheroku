require_relative '../dinesafe/update_geo'
require_relative '../dinesafe/update_dinesafe'

namespace :seed do

  @verbose = true
  @verbose_geo = false

  def extract_timestamp_from_filename(filename)
    filename.split('/').last.split('_').first.split('.').first
  end 

  desc "temp Strip single quotes from Address table"
  task :fixadd => :environment do
    to_fix = Address.select(:id, :streetname).where('streetname like ? ', "%'%")
    to_fix.each do |badaddr|
      Address.update(badaddr.id, :streetname => badaddr.streetname.remove("'"))
    end
  end
  
  desc "WARNING: MAY TAKE SEVERAL HOURS TO COMPLETE. read latest geo file and update or create records"
  task :geo => :environment do
    latest_downloads = Download.instance
    if latest_downloads.geo_done != true    
      geopath = latest_downloads.latest_geo
      
      timestamp = 0
      # if no timestamp extract from filename and save timestamp
      if latest_downloads.geoversion.nil?
        timestamp = extract_timestamp_from_filename(geopath)
        latest_downloads.geoversion = timestamp
      else
        timestamp = latest_downloads.geoversion
      end

      updater = UpdateGeo.new(geopath, @verbose_geo, timestamp)
      
      updater.process()
      latest_downloads.geo_done = true
      latest_downloads.save
    end
  end

  desc "Process dinsafe XML"
  task :dinesafe => :environment do
    latest_downloads = Download.instance
    if latest_downloads.xml_done != true 
      puts 'processing'   
      xmlpath = latest_downloads.latest_xml
      
      timestamp = 0
      # if no timestamp extract from filename and save timestamp
      if latest_downloads.xmlversion.nil?
        timestamp = extract_timestamp_from_filename(xmlpath)
        latest_downloads.xmlversion = timestamp
      else
        timestamp = latest_downloads.xmlversion
      end

      updater = UpdateDinesafe.new(xmlpath, @verbose, timestamp)
      updater.process()
      latest_downloads.xml_done = true
      latest_downloads.save
    end
  end

end