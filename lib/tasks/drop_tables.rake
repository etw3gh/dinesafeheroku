namespace :drop do

  # add tables only as necessary
  desc "drops inspection related tables"
  task :insp => :environment do
    ActiveRecord::Migration.drop_table(:inspections)
    ActiveRecord::Migration.drop_table(:notfounds)
    ActiveRecord::Migration.drop_table(:multiples)
    ActiveRecord::Migration.drop_table(:venues)
    ActiveRecord::Migration.drop_table(:bad_venues)
  end