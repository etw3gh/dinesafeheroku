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
    puts(@geo_zip)
    @FH.get_filenames(@geo_zip).each do |f|
      puts(f)
      # retrieve timestamp encoded in filename
      ts = @FH.extract_timestamp(f)
      puts(ts)
      # form timestamp path
      ts_path = "#{@geo_zip}#{ts}"

      # make a directory from the timestamp to hold the shapefiles
      @FH.make_dir(ts_path)

      Zip::File.open(f) do |archive_file|
        puts "extracting: #{archive_file.name}"
        dest_path = "#{ts_path}/#{archive_file.name}"
        archive_file.extract(dest_path)
      end
    end
  end
end