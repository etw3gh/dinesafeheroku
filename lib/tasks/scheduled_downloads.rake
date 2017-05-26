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
    
    # get current timestamp in order to set unique filename
    timestamp = Time.now.to_i

    xml_dl = Downloader.new(@xml_url)
    shape_dl = Downloader.new(@geo_url)

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

    # if local xml last mod is less than server last mod, then downloader
    # first run will always download because it is set to zero
    if (ld_lastmod_xml < xml_dl.last_mod)
      get_file(@xml_url, @xml_zip, xml_dl)

      # xml_fn = @FH.extract_filename(@xml_url)
      # xml_ts_fn = @FH.make_unique_filename(xml_dl.last_mod, xml_fn)
      # xml_path = "#{@xml_zip}#{xml_ts_fn}"
      # xml_dl.download(xml_path)
      # md5 = Digest::MD5.file(xml_path).hexdigest
      # LatestDownload.instance.update(:lastmodxml=>xml_dl.last_mod, :md5xml=>md5)
    end
    if (ld_lastmod_geo < shape_dl.last_mod)
      get_file(@geo_url, @geo_zip, shape_dl)

      # geo_fn = @FH.extract_filename(@geo_url)
      # geo_ts_fn = @FH.make_unique_filename(shape_dl.last_mod, geo_fn)
      # geo_path = "#{@geo_zip}#{geo_ts_fn}"
      # geo_dl.download(geo_path)
      # md5 = Digest::MD5.file(geo_path).hexdigest
      # LatestDownload.instance.update(:lastmodgeo=>shape_dl.last_mod, :md5geo=>md5)
    end
  end

  def get_file(url, zip_path, downloader)
    fn = @FH.extract_filename(url)
    ts_fn = @FH.make_unique_filename(downloader.last_mod, fn)
    path = "#{zip_path}#{ts_fn}"
    downloader.download(path)
    md5 = Digest::MD5.file(path).hexdigest
    LatestDownload.instance.update(:lastmodxml=>downloader.last_mod, :md5xml=>md5)
  end

end