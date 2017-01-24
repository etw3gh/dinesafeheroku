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

end