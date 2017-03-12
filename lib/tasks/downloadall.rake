require_relative('../dinesafe/downloader')
require_relative('../dinesafe/update_dinesafe')
require 'open-uri'

namespace :get do 

  @all_archives_service = 'https://openciti.ca/cgi-bin/ds/all'
  @ocurl = 'https://openciti.ca/ds/'

  @VERBOSE = true

  # for is_geo column in Archive model
  @XML_CASE = false
  @GEO_CASE = true

  def extract_timestamp_from_filename(filename)
    filename.split('/').last.split('_').first.split('.').first
  end 

  # if status == 200: returns xml, geo arrays of filenames
  # if status != 200: throws exception
  def get_archive_filenames
    downloader = Downloader.new()
    archive_response = downloader.get_data_object(@all_archives_service)
    status = archive_response['status']

    if status == 200
      xml = archive_response['xml']
      geo = archive_response['geo']

      return xml, geo
    else
      raise "Error getting filenames from web service #{@all_archives_service}. status: #{status}\n"
    end
  end 

  def print_filenames_return_menu_dict(printmenuoptions=true)
    menu_dict = {}
    begin
      xml, geo = get_archive_filenames
      
      # menu indices (add one for filename pos in arrays)
      xml_start = 0
      geo_start = xml.count
      all_xml = xml.count + geo.count + 1
      all_geo = all_xml + 1
      all_archives = all_geo + 1
      puts "XML"
      xml.to_enum.with_index(1) do |xml_file, i|
        xml_archive = Archive.where(:filename => xml_file).first
        menu_dict[i] = xml_file        
        if xml_archive.blank? 
          puts "#{i}: #{xml_file}, processed: FALSE"
        else
          pstart = xml_archive.startprocessing
          pend = xml_archive.endprocessing
          processed = xml_archive.processed.to_str.upcase
          count = xml_archive.count
          puts "#{i}: #{xml_file}, processed: #{processed}, count: #{count}, processed start: #{pstart}, processed end: #{pend}"          
        end 
      end

      puts "\nGEO"
      geo.to_enum.with_index(geo_start + 1) do |geo_file, i|
        geo_archive = Archive.where(:filename => geo_file).first
        menu_dict[i] = geo_file
        if geo_archive.blank?
          puts "#{i}: #{geo_file}, processed: FALSE"
        else          
          pstart = geo_archive.startprocessing
          pend = geo_archive.endprocessing
          processed = xml_archive.processed.to_str.upcase
          count = xml_archive.count
          puts "#{i}: #{geo_file}, processed: #{processed}, count: #{count}, processed start: #{pstart}, processed end: #{pend}"
        end 

      end

      menu_dict[all_xml] = "#{all_xml}: All XML"
      menu_dict[all_geo] = "#{all_geo}: ALL GEO"
      menu_dict[all_archives] = "#{all_archives}: GET EVERYTHING"
      menu_dict['q'] = "q: Quit"
      if printmenuoptions
        puts menu_dict[all_xml]
        puts
        puts menu_dict[all_geo]
        puts menu_dict[all_archives]
        puts 
        puts menu_dict['q']
      end
      return xml, geo, menu_dict      
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
    end    
  end
  # an administrative helper
  # 
  desc "get the archive filenames from openciti.ca helper service and shows if it has been processed"
  task :filenames => :environment do
    #print filenames without menu options (all xml, all geo, quit)
    print_filenames_return_menu_dict(false)
  end

  # accepts an array of URI's or a single URI
  def process_geo(geo)
    if !geo.kind_of(Array)
      geo = [geo]
    end 
    geo.each do |geo_file|
      puts geo_file
      geo_path = @ocurl + geo_file
      timestamp = extract_timestamp_from_filename(geo_path)
      archive_processed = Archive.where(:filename => geo_file, :processed => true).first
      puts archive_processed
      if archive_processed.blank?
        start_processing = Time.now
        updater = UpdateGeo.new(geo_path, @VERBOSE, timestamp)
        updater.process
        end_processing = Time.now
        record_count = Address.where(:version => timestamp).count
        if Archive.where(:filename => geo_file).blank?
          #insert case 
          puts 'inserting...'
          Archive.where(:startprocessing => start_processing,
                        :endprocessing => end_processing,
                        :count => record_count,
                        :version => timestamp,
                        :processed => true,
                        :is_geo => @GEO_CASE).first_or_create(:filename => geo_file)
        else
          puts 'updating...'
          archive = Archive.where(:filename => geo_file).first
          archive.update(:processed => true,
                          :startprocessing => start_processing,
                          :endprocessing => end_processing,
                          :count => record_count)
        end
      end        
    end
  end 

  # accepts an array of URI's or a single URI
  def process_xml(xml)
    if !xml.kind_of(Array)
      xml = [xml]
    end

    xml.each do |xml_file|
      xml_path = @ocurl + xml_file
      timestamp = extract_timestamp_from_filename(xml_path)

      if Archive.where(:filename => xml_file, :processed => true).blank?
        start_processing = Time.now
        updater = UpdateDinesafe.new(xml_path, @VERBOSE, timestamp)
        updater.process
        end_processing = Time.now
        record_count = Inspections.where(:created_at => timestamp).count
        if Achive.where(:filename => xml_file).blank?
          #insert case 
          Archive.where(:startprocessing => start_processing,
                        :endprocessing => end_processing,
                        :count => record_count,
                        :version => timestamp,
                        :processed => true,
                        :is_geo => @XML_CASE).first_or_create(:filename => xml_file)
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

  desc "update xml files"
  task :xml => :environment do
    xml, geo = get_archive_filenames
    process_xml(xml)    
  end

  desc "update geo files"
  task :geo => :environment do
    xml, geo = get_archive_filenames
    process_geo(geo)    
  end

  desc "interactive rake task to process one or more archives or archive groups"
  task :menu => :environment do
    xml, geo, menu_dict = print_filenames_return_menu_dict
    input = STDID.gets.strip.downcase
    if input.key?(menu_dict)
      puts "processing #{menu_dict[input]}"
    else
      puts 'Invalid menu option, try again'
    end
  end

  desc "goes over all archive URIs and will process if required"
  task :all => :environment do
    xml, geo, menu_dict = print_filenames_return_menu_dict
    
  end

end