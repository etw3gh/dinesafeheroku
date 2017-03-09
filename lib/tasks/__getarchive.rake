# DEPRECIATED

require_relative('../dinesafe/downloader')
require 'open-uri'

namespace :arch do

  @dl_path = 'lib/assets/'
  @latest_service = 'https://openciti.ca/cgi-bin/ds/latest'
  @ocurl = 'https://openciti.ca/ds/'

  # forchecking versions
  @min_inspections = 82000
  @min_addresses = 520000
  @min_venues = 10000
  

  def extract_timestamp_from_filename(filename)
    filename.split('/').last.split('_').first.split('.').first
  end 

  def purgefiles(endswith)
    Dir.foreach(@dl_path) do |item|
      next if item[0] == '.'
      if item.end_with? endswith
        path = File.join(@dl_path, item)
        ret = File.delete(path) if File.exist?(path)
        puts "deleted: #{path}" if ret == 1
      end
    end
  end

  def setgeo(path, isdone, timestamp)
    d = Download.instance
    d.latest_geo = path
    d.geo_done = isdone
    d.geoversion = timestamp
    d.save
  end

  def setxml(path, isdone, timestamp)
    d = Download.instance
    d.latest_xml = path
    d.xml_done = isdone
    d.xmlversion = timestamp
    d.save
  end


  desc "purge geo archives"
  task :rmgeo => :environment do
    purgefiles('json')
    setgeo('', false, 0)
  end

  desc "purge xml archives"
  task :rmxml => :environment do
    purgefiles('xml')
    setxml('', false, 0)
  end

  desc "sets xml_done to false to enable reprocessing of xml data"
  task :resetxml => :environment do
    d = Download.instance    
    d.xml_done = false
    d.save    
  end

  desc "show download singleton values"
  task :downloads => :environment do
    d = Download.instance    
    x = d.latest_xml
    g = d.latest_geo  
    xd = d.xml_done
    gd = d.geo_done
    xv = d.xmlversion
    gv = d.geoversion
    puts "xml: #{x} done: #{xd}, ver: #{xv}\ngeo: #{g} done: #{gd}, ver: #{gv}"
  end

  # call from :fixdl task as well asl :get task
  def fixdl
    # Obtain Download Model
    d = Download.instance    
    latestxml = d.latest_xml
    latestgeo = d.latest_geo  
    
    # if file exists, set values in Download model
    dl = Downloader.new()
    check = dl.get_data_object(@latest_service)     
    status = check['status']

    if status == 200
      xml = check['xml']
      geo = check['geo']
    else
      puts "error. status: #{status}"
    end
    xml_dl_path = File.join(@dl_path, xml)
    xml_timestamp = extract_timestamp_from_filename(xml_dl_path)

    geo_dl_path = File.join(@dl_path, geo)
    geo_timestamp = extract_timestamp_from_filename(geo_dl_path)

    if File.file?(xml_dl_path) && (latestxml.nil? or latestxml.empty?)
      d.latest_xml = xml_dl_path
      check_version = Inspection.where(:version=>xml_timestamp).count
      if check_version < @min_inspections
        d.xml_done = false
        d.xmlversion = xml_timestamp
      end
    end

    if File.file?(geo_dl_path) && (latestgeo.nil? or latestgeo.empty?)
      d.latest_geo = geo_dl_path
      check_version = Address.where(:version=>geo_timestamp).count
      if check_version < @min_addresses
        d.geo_done = false
        d.geoversion = geo_timestamp
      end
    end
    d.save
  end

  desc "fix Download model if files exist"
  task :fixdl => :environment do
    fixdl
  end

  desc "download new dinesafe zip file"
  task :get => :environment do

    dl = Downloader.new()
    check = dl.get_data_object(@latest_service)     
    status = check['status']

    if status == 200
      xml = check['xml']
      geo = check['geo']
    else
      puts "error. status: #{status}"
    end
    
    xml_dl_path = File.join(@dl_path, xml)
    xml_url = File.join(@ocurl, xml)
    xml_version = extract_timestamp_from_filename(xml_dl_path)

    geo_dl_path = File.join(@dl_path, geo)
    geo_url = File.join(@ocurl, geo)
    geo_version = extract_timestamp_from_filename(geo_dl_path)

    # if the timestamped file exists, then don't download it  
    if !File.file?(xml_dl_path)
      puts 'getting xml...'
      xml_response = open(xml_url)
      IO.copy_stream(xml_response, xml_dl_path)

      # if the file downloaded, store in singleton model,
      # set the done flag to false 
      setxml(xml_dl_path, false, xml_version) if File.file?(xml_dl_path)    
    else
      puts "xml up to date. #{xml} exists"
    end

    if !File.file?(geo_dl_path)    
      puts 'getting geo...'
      geo_response = open(geo_url)   
      IO.copy_stream(geo_response, geo_dl_path)

      # if the file downloaded, store in singleton model,
      # set the done flag to false 
      setgeo(geo_dl_path, false, geo_version) if File.file?(geo_dl_path)
    else
      puts "geo up to date. #{geo} exists"
    end

  end

# end namespace
end