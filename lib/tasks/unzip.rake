require_relative('../file_helper')

require 'rubygems'
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

      Zip::File.open(f) do |zip_file|

      end
    end
  end
end