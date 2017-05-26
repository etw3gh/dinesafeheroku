require_relative('../dinesafe/downloader')
require_relative('../acquisitions')
require_relative('../file_helper')
require 'digest'



namespace :sched do

  xml_acq = Acquisitions.instance.dinesafe
  geo_acq = Acquisitions.instance.shapefiles

  @xml_txt = xml_acq[:textfiles]
  @xml_zip = xml_acq[:archives]
  @xml_url = xml_acq[:url]

  @geo_txt = geo_acq[:textfiles]
  @geo_zip = geo_acq[:archives]
  @geo_url = geo_acq[:url]

  @FH = FileHelper.new


  task :dl => :environment do
    xml_dl = Downloader.new(@xml_url)
    shape_dl = Downloader.new(@geo_url)
    xml_downloaded = false
    geo_downloaded = false

    # store last mods to prevent duplicate header calls
    shape_last_mod = shape_dl.last_mod
    xml_last_mod =  xml_dl.last_mod

    ld = LatestDownload.instance
    # Set local last mod to zero if the model is empty (first run)
    # Otherwise set to the stored value
    if (ld.lastmodxml.blank?)
      ld_lastmod_xml = 0
    else
      ld_lastmod_xml = ld.lastmodxml
    end
    if (ld.lastmodgeo.blank?)
      ld_lastmod_geo = 0
    else
      ld_lastmod_geo = ld.lastmodgeo
    end

    # if local last mod is less than server last mod, then downloader
    # first run will always download because it is set to zero
    if (ld_lastmod_xml < xml_last_mod)
      md5 = get_file(@xml_url, @xml_zip, xml_dl, xml_last_mod)
      LatestDownload.instance.update(:lastmodxml=>xml_last_mod, :md5xml=>md5)
      xml_downloaded = true
    end

    # repeat for geo data
    if (ld_lastmod_geo < shape_last_mod)
      md5 = get_file(@geo_url, @geo_zip, shape_dl, shape_last_mod)
      LatestDownload.instance.update(:lastmodgeo=>shape_last_mod, :md5geo=>md5)
      geo_downloaded = true
    end


    puts '\n\n----------------'
    puts 'SCHEDULED DL OUTCOME:'
    xout = 'NOT ' if !xml_downloaded
    gout = 'NOT ' if !geo_downloaded
    puts 'xml file #{xout}downloaded'
    puts 'geo file #{gout}downloaded'
    puts '----------------\n'
  end

  def get_file(url, zip_path, downloader, last_mod)
    fn = @FH.extract_filename(url)
    ts_fn = @FH.make_unique_filename(last_mod, fn)
    path = "#{zip_path}#{ts_fn}"
    downloader.download(path)
    md5 = Digest::MD5.file(path).hexdigest
    md5
  end


  task :resetdl => :environment do
    LatestDownload.instance.update(:lastmodxml=>nil, :md5xml=>nil,:lastmodgeo=>nil, :md5geo=>nil)
  end

end
