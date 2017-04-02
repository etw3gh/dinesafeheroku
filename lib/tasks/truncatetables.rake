namespace :trunc do

  # add tables only as necessary
  desc "xml related inpection related tables"
  task :xml => :environment do
    Inspection.delete_all
    Notfound.delete_all
    Multiple.delete_all
    Venue.delete_all
    BadVenue.delete_all
    Archive.where(:is_geo => false).delete_all
  end

  desc "truncate inspections table"
  task :inspections => :environment do
    Inspection.delete_all
    Archive.where(:is_geo => false).delete_all
  end

  desc "trunc error tables"
  task :err => :environment do
    Notfound.delete_all
    Multiple.delete_all    
  end

  desc "truncate venues table"
  task :venues => :environment do
    Venue.delete_all
  end

  desc "truncate addresses table"
  task :addresses => :environment do
    Address.delete_all
    Archive.where(:is_geo => true).delete_all
  end


  desc "truncate archives table"
  task :archives => :environment do
    DatabaseCleaner.clean_with(:truncation, :only =>['archives'])
  end

end