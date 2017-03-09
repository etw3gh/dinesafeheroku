require_relative('../dinesafe/downloader')
require_relative('../dinesafe/update_dinesafe')
require 'open-uri'

namespace :get do 

  @all_archives_service = 'https://openciti.ca/cgi-bin/ds/all'
  @ocurl = 'https://openciti.ca/ds/'

  @BY_URL = true
  @VERBOSE = true

  # for is_geo column in Archive model
  @XML_CASE = false
  @GEO_CASE = true

  def extract_timestamp_from_filename(filename)
    filename.split('/').last.split('_').first.split('.').first
  end 


  # first process geo.
  # then process all xmls, skipping if Achives table has processed=true for given timestamp

  desc "get all archives"
  task :all => :environment do
    downloader = Downloader.new()
    archive_response = downloader.get_data_object(@all_archives_service)
    if archive_response['status'] == 200
      xml = archive_response['xml']
      geo = archive_response['geo']
      

      geo.each do |geo_file|
        geo_path = @ocurl + geo_file
        timestamp = extract_timestamp_from_filename(geo_path)

        if Archive.where(:filename => geo_file, :processed => true).blank?
          start_processing = Time.now.to_i
          updater = UpdateGeo.new(geo_path, @VERBOSE, timestamp)
          end_processing = Time.now.to_i
          record_count = Inspections.where(:created_at => timestamp).count
          if Achive.where(:filename => xml_file).blank?
            #insert case 
            Archive.where(:startprocessing => start_processing,
                          :endprocessing => end_processing,
                          :count => record_count,
                          :version => timestamp,
                          :processed => true,
                          :is_geo @XML_CASE).first_or_create(:filename => xml_file)
          else
            archive = Archive.where(:filename => xml_file).first
            archive.update(:processed => true,
                           :startprocessing => start_processing,
                           :endprocessing => end_processing,
                           :count => record_count)
          end        
      end


      xml.each do |xml_file|
        xml_path = @ocurl + xml_file
        timestamp = extract_timestamp_from_filename(xml_path)

        if Archive.where(:filename => xml_file, :processed => true).blank?
          start_processing = Time.now.to_i
          updater = UpdateDinesafe.new(xml_path, @VERBOSE, timestamp, @BY_URL)
          end_processing = Time.now.to_i
          record_count = Inspections.where(:created_at => timestamp).count
          if Achive.where(:filename => xml_file).blank?
            #insert case 
            Archive.where(:startprocessing => start_processing,
                          :endprocessing => end_processing,
                          :count => record_count,
                          :version => timestamp,
                          :processed => true,
                          :is_geo @XML_CASE).first_or_create(:filename => xml_file)
          else
            archive = Archive.where(:filename => xml_file).first
            archive.update(:processed => true,
                           :startprocessing => start_processing,
                           :endprocessing => end_processing,
                           :count => record_count)
          end
        end
      end

    end
  end
end