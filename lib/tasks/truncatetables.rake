namespace :trunc do

  # add tables only as necessary

  desc "truncate inspections table"
  task :inspections => :environment do
    DatabaseCleaner.clean_with(:truncation, :only =>['inspections'])
  end

  desc "truncate venues table"
  task :venues => :environment do
    DatabaseCleaner.clean_with(:truncation, :only =>['venues'])
  end

  desc "truncate addresses table"
  task :addresses => :environment do
    DatabaseCleaner.clean_with(:truncation, :only =>['addresses'])
  end

end