namespace :ver do
  desc "verify every inspection has a valid venue"
  task :venues => :environment do
    query = "SELECT DISTINCT eid FROM inspections WHERE eid NOT IN (SELECT DISTINCT eid FROM venues);"
    rows = ActiveRecord::Base.connection.execute(query)
    if rows.count == 0
      puts "VENUES OK"
    else
      puts "MISSING #{rows.count} Venues\n"
      puts rows
    end
  end
end