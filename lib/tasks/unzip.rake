require_relative('../file_helper')

require 'zip'

namespace :unzip do
  xml_acq = Acquisitions.instance.dinesafe
  geo_acq = Acquisitions.instance.shapefiles

  @xml_txt = xml_acq[:textfiles]
  @xml_zip = xml_acq[:archives]

  @geo_txt = geo_acq[:textfiles]
  @geo_zip = geo_acq[:archives]
  @geo_shp = geo_acq[:shapefiles]

  @FH = FileHelper.new

  task :xml => :environment do
    @FH.get_filenames(@xml_zip).each do |f|
      ts = @FH.extract_timestamp(f)
      
      # form a filename according to the format {timestamp}_dinesafe.xml
      timestamped_xml_filename = "#{ts}_dinesafe.xml"

      # only proceed if the file does not exist
      if !File.file?(timestamped_xml_filename)
        # we are just extracting a single file here, no processing is involved
        # form zip path (source file)
        zip_path = "#{@xml_zip}#{f}"

        # send timestamp as prefix to unzip method
        @FH.extract_zip(zip_path, @xml_txt, ts)
      end
    end
  end

  task :geo => :environment do

    @FH.get_filenames(@geo_zip).each do |f|

      # retrieve timestamp encoded in filename
      ts = @FH.extract_timestamp(f)

      # form timestamp path
      ts_path = "#{@geo_shp}#{ts}"

      # form zip path (source file)
      zip_path = "#{@geo_zip}#{f}"

      @FH.extract_zip(zip_path, ts_path)
    end
  end
end