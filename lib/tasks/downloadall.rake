require_relative('../dinesafe/downloader')
require_relative('../dinesafe/update_dinesafe')
require 'open-uri'

namespace :get do 

  @all_archives_service = 'https://openciti.ca/cgi-bin/ds/all'
  @ocurl = 'https://openciti.ca/ds/'

  @BY_URL = true
  @VERBOSE = true

  def extract_timestamp_from_filename(filename)
    filename.split('/').last.split('_').first.split('.').first
  end 


  # first process geo.
  # then process all xmls, skipping if Achives table has processed=true for given timestamp

  desc "get all archives"
  task :all => :environment do
    downloader = Downloader.new()
    archive_response = downloader.check_latest(@all_archives_service)
    if archive_response['status'] == 200
      xml = archive_response['xml']
      geo = archive_response['geo']
      

      geo.each do |geo_file|
        puts geo_file
      end


      xml.each do |xml_file|
        xml_path = @ocurl + xml_file
        puts xml_path
        timestamp = extract_timestamp_from_filename(xml_path)

        start_processing = Time.now.to_i
        updater = UpdateDinesafe.new(xml_path, @VERBOSE, timestamp, @BY_URL)
        end_processing = Time.now.to_i


      end

    end
  end
end