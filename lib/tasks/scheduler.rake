require_relative('../dinesafe/downloader')


desc "Test of Heroku scheduler add-on"
task :a => :environment do
  puts "Task a"
  puts "done."
end



