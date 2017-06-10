namespace :drop do

  # add tables only as necessary
  desc "drops inspection related tables"
  task :insp => :environment do
    insp_tables = [:inspections, :notfounds, :multiples, :venues, :bad_venues]

    insp_tables.each do |t|
      begin
        ActiveRecord::Migration.drop_table(t)
      rescue ActiveRecord::StatementInvalid
        puts("--- #{t} is undefined ---")
      end
    end
  end
end