namespace :drop do

  # add tables only as necessary
  desc "drops inspection related tables"
  task :insp => :environment do
    insp_tables = [:inspections, :notfounds, :multiples, :venues, :bad_venues]

    insp_tables.each do |t|
      puts t
      if ActiveRecord::Base.connection.table_exists? t
        ActiveRecord::Migration.drop_table(t)
      else
        puts("--- #{t} is undefined ---\n")
      end
    end
  end
end