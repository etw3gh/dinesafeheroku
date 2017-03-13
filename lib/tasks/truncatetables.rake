namespace :trunc do

  # add tables only as necessary

  desc "truncate inspections table"
  task :inspections => :environment do
    DatabaseCleaner.clean_with(:truncation, :only =>['inspections'])
  end

  desc "trunc error tables"
  task :err => :environment do
    DatabaseCleaner.clean_with(:truncation, :only =>['notfounds'])
    DatabaseCleaner.clean_with(:truncation, :only =>['multiples'])    
  end

  desc "truncate venues table"
  task :venues => :environment do
    DatabaseCleaner.clean_with(:truncation, :only =>['venues'])
  end

  desc "truncate addresses table"
  task :addresses => :environment do
    DatabaseCleaner.clean_with(:truncation, :only =>['addresses'])
  end


  desc "truncate archives table"
  task :archives => :environment do
    DatabaseCleaner.clean_with(:truncation, :only =>['archives'])
  end

end