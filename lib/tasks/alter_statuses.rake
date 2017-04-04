namespace :status do
  # cleanup task, new inserts will not require conversion
  desc "change 'conditional pass' to 'condpass'"
  task :alter => :environment do
    Inspection.where(:status=>'conditional pass').update_all(status: 'condpass')
  end

end