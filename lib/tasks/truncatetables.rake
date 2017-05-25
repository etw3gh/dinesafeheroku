def truncate (model)
  table = model.table_name
  model.delete_all
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE #{table}_id_seq RESTART WITH 1;")
end

namespace :trunc do

  # add tables only as necessary
  desc "xml related inpection related tables"
  task :xml => :environment do
    truncate(Inspection)
    truncate(Notfound)
    truncate(Multiple)
    truncate(Venue)
    truncate(BadVenue)
    Archive.where(:is_geo => false).delete_all
  end

  desc "truncate inspections table"
  task :inspections => :environment do
    truncate(Inspection)
    Archive.where(:is_geo => false).delete_all
  end

  desc "trunc error tables"
  task :err => :environment do
    truncate(Notfound)
    truncate(Multiple)
  end

  desc "truncate venues table"
  task :venues => :environment do
    truncate(Venue)
  end

  desc "truncate addresses table"
  task :addresses => :environment do
    truncate(Address)
    Archive.where(:is_geo => true).delete_all
  end


  desc "truncate archives table"
  task :archives => :environment do
    truncate(Archive)
  end

end