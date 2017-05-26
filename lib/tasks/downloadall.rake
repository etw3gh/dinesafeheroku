require_relative('../dinesafe/downloader')
require_relative('../acquisitions')
require_relative('../file_helper')
require_relative('../dinesafe/update_dinesafe')
require_relative('../dinesafe/update_geo')
require 'open-uri'

namespace :get do

  @all_archives_service = 'https://openciti.ca/cgi-bin/ds/all'
  @ocurl = 'https://openciti.ca/ds/'

  @VERBOSE = true

  # for is_geo column in Archive model
  @XML_CASE = false
  @GEO_CASE = true

  # menu text and options
  @all_xml_menu = "All XML"
  @all_geo_menu = "ALL GEO"
  @all_menu = "GET EVERYTHING"

  xml_acq = Acquisitions.instance.dinesafe
  geo_acq = Acquisitions.instance.shapefiles

  xml_txt = xml_acq[:textfiles]
  geo_txt = geo_acq[:textfiles]
  puts 'test'
  puts xml_txt, geo_txt

 def extract_timestamp_from_filename(filename)
    filename.split('/').last.split('_').first.split('.').first
  end

  def no_utc(d)
    d.to_s.chomp(' UTC')
  end

  # if status == 200: returns xml, geo arrays of filenames
  # if status != 200: throws exception

  # TODO: MODIFY THIS TO READ FROM LOCAL DIRECTORIES, NOT A WEB SERVICE
  def get_archive_filenames_old
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

  # modified to search local directory instead of remote service
  def get_filenames
    file_helper = FileHelper.new

    xml_acq = Acquisitions.instance.dinesafe
    geo_acq = Acquisitions.instance.shapefiles
    data_obj = { geo: { archives: [], textfiles: []}, xml: { archives: [], textfiles: []} }

    garch = file_helper.get_filenames(geo_acq[:archives])
    gtxt = file_helper.get_filenames(geo_acq[:textfiles])

    xarch = file_helper.get_filenames(xml_acq[:archives])
    xtxt = file_helper.get_filenames(xml_acq[:textfiles])

    data_obj[:geo][:archives].concat(garch)
    data_obj[:geo][:textfiles].concat(gtxt)
    data_obj[:xml][:archives].concat(xarch)
    data_obj[:xml][:textfiles].concat(xtxt)

    data_obj
  end

  task :local => :environment do
    puts get_filenames
  end

  # refactored out of :getoc task
  def dl_list(dl_files, text_path)
    file_helper = FileHelper.new
    dl_files.each do |dl_file|
      url = "#{@ocurl}#{dl_file}"
      d = Downloader.new(url)

      # remove pythyon .0 timestamp artifact from filename
      filename_zero_stripped = file_helper.rmzero(dl_file)

      local_path = "#{text_path}#{filename_zero_stripped}"
      d.download(local_path)
    end
  end

  # one off task. converting the python service into rails
  # downloads the files on the helper server to the local rails server
  # goal is to modify other rake tasks to seek files locally instead of on the server
  # moving forward, the zip files and shape files will be stored as well
  # result after task is run:
  """
    downloads
    ├── dinesafe
    │   ├── xml
    │   │   ├── 1483469307_dinesafe.xml
    │   │   ├── 1484577503_dinesafe.xml
    │   │   ├── 1486579098_dinesafe.xml
    │   │   ├── 1487001084_dinesafe.xml
    │   │   ├── 1488832096_dinesafe.xml
    │   │   ├── 1490721006_dinesafe.xml
    │   │   ├── 1491832647_dinesafe.xml
    │   │   └── 1493045091_dinesafe.xml
    │   └── zip
    └── geo
        ├── json
        │   ├── 1474461890_geo.json
        │   └── 1491231264_geo.json
        ├── shp
        └── zip
  """
  task :oc => :environment do
    xml, geo = get_archive_filenames

    xml_acq = Acquisitions.instance.dinesafe
    geo_acq = Acquisitions.instance.shapefiles

    xml_txt = xml_acq[:textfiles]
    geo_txt = geo_acq[:textfiles]

    dl_list(xml, xml_txt)
    dl_list(geo, geo_txt)
  end



  def print_filenames_return_menu_dict(printmenuoptions=true)
    menu_dict = {}
    begin
      local_files = get_filenames
      xml = local_files[:xml][:textfiles]
      geo = local_files[:geo][:textfiles]

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
          pstart = no_utc(xml_archive.startprocessing)
          pend = no_utc(xml_archive.endprocessing)
          processed = xml_archive.processed ? "TRUE" : "FALSE"
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
          pstart = no_utc(geo_archive.startprocessing)
          pend = no_utc(geo_archive.endprocessing)
          processed = geo_archive.processed ? "TRUE" : "FALSE"
          count = geo_archive.count
          puts "#{i}: #{geo_file}, processed: #{processed}, count: #{count}, start: #{pstart}, end: #{pend}"
        end

      end

      menu_dict[all_xml] = "#{all_xml}: #{@all_xml_menu}"
      menu_dict[all_geo] = "#{all_geo}: #{@all_geo_menu}"
      menu_dict[all_archives] = "#{all_archives}: #{@all_menu}"
      menu_dict['q'] = "q: Quit"
      if printmenuoptions
        puts
        puts menu_dict[all_xml]
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
  desc "get the archive filenames from openciti.ca helper service and shows if it has been processed"
  task :fileinfo => :environment do
    print_filenames_return_menu_dict(false)
  end



  # accepts an array of URI's or a single URI
  # TODO should accept a filepath instead
  def process_geo(geo)

    # if the input is not an array, put wrap it in one
    if !geo.is_a? Array
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
        begin
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
        rescue ActiveRecord::RecordNotUnique => e
          puts "FAILED TO ADD ARCHIVE RECORD: #{geo_file} #{e.message}"
        end
      end
    end
  end

  # accepts an array of URI's or a single URI
  def process_xml(xml)

    # if the input is not an array, put wrap it in one
    if !xml.is_a? Array
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
        record_count = Inspection.where(:version => timestamp).count
        begin
          if Archive.where(:filename => xml_file).blank?
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
        rescue ActiveRecord::RecordNotUnique => e
          puts "FAILED TO ADD ARCHIVE RECORD: #{xml_file} #{e.message}"
        end
      end
    end
  end

  desc "update xml files"
  task :xml => :environment do
    local_files = get_filenames
    xml = local_files[:xml][:textfiles]
    process_xml(xml)
  end

  desc "update geo files"
  task :geo => :environment do
      local_files = get_filenames
      geo = local_files[:geo][:textfiles]
    process_geo(geo)
  end

  desc "interactive rake task to process one or more archives or archive groups"
  task :menu => :environment do
    bye = "\nBye"
    xml, geo, menu_dict = print_filenames_return_menu_dict

    # if input is not an int, then exit
    begin
      input = STDIN.gets.strip.to_i
    rescue
      puts bye
      return
    end

    if menu_dict.has_key?(input)
      choice = menu_dict[input]
      puts "\nprocessing #{choice}"
      if choice.include?(@all_menu)
        process_xml(xml)
        process_geo(geo)
      elsif choice.include?(@all_xml_menu)
        process_xml(xml)
      elsif choice.include?(@all_geo_menu)
        process_geo(geo)
      else
        if choice.include?('.xml')
          process_xml(choice)
        elsif choice.include?('geo.json')
          process_geo(choice)
        else
          puts 'invalid choice'
        end
      end
    else
      puts bye
    end

  end

  desc "goes over all archive URIs and will process if required"
  task :all => :environment do
    local_files = get_filenames
    xml = local_files[:xml][:textfiles]
    geo = local_files[:geo][:textfiles]
    process_xml(xml)
    process_geo(geo)
  end



end