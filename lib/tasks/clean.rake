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
    Archive.all.each do |a|
      fn = a.filename.sub('.0', '')
      a.update_attribute(:filename, fn)
    end
  end
end