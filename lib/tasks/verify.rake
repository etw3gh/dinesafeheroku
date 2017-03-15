namespace :ver do
  desc "verify every inspection has a valid venue"
  task :venues => :environment do
    query = "SELECT DISTINCT eid FROM inspections WHERE eid NOT IN (SELECT DISTINCT eid FROM venues);"
    rows = ActiveRecord::Base.connection.execute(query).count
    puts rows 
  end
end