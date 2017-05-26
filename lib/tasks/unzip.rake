require_relative('../file_helper')

require 'zip'

namespace :unzip do
  xml_acq = Acquisitions.instance.dinesafe
  geo_acq = Acquisitions.instance.shapefiles

  @xml_txt = xml_acq[:textfiles]
  @xml_zip = xml_acq[:archives]

  @geo_txt = geo_acq[:textfiles]
  @geo_zip = geo_acq[:archives]

  @FH = FileHelper.new

  task :xml => :environment do
    puts @FH.get_filenames(@xml_zip)

  end

  task :geo => :environment do

    @FH.get_filenames(@geo_zip).each do |f|

      # retrieve timestamp encoded in filename
      ts = @FH.extract_timestamp(f)

      # form timestamp path
      ts_path = "#{@geo_zip}#{ts}"

      @FH.extract_zip(@geo_zip, ts_path)
    end
  end
end