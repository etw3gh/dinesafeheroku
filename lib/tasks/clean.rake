require_relative('../file_helper')
# collection of one off rake tasks
# used rarely or only one time
namespace :clean do

  desc "purge single quotes from streetnames"
  task :addresses => :environment do
    Address.all.each do |address|
      streetcleaner = address.streetname.downcase.remove("'")
      address.update_attribute(:streetname, streetcleaner)
    end
  end

  desc "remove .0 from timestamped filenames i Archive"
  task :rem0 => :environment do
    file_helper = FileHelper.new
    Archive.all.each do |a|
      
      #remove .0 from python generated timestamped filename
      fn = file_helper.rmzero(a.filename)
      
      a.update_attribute(:filename, fn)
    end
  end
end