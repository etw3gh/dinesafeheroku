namespace :clean do

  desc "purge single quotes from streetnames"
  task :addresses => :environment do
    Address.all.each do |address|
      streetcleaner = address.streetname.downcase.remove("'")
      address.update_attribute(:streetname, streetcleaner)
    end
  end

end