# NOTE: A rails server must be running locally at all times 
# `rails s &` for background operation 

# WARNING: not for heroku, the data will be pushed by pgpush after processing
 

# DO NOT INVOKE for rake OR console
# https://github.com/jmettraux/rufus-scheduler#so-rails
# https://github.com/jmettraux/rufus-scheduler#avoid-scheduling-when-running-the-ruby-on-rails-console

unless defined?(Rails::Console) || File.split($0).last == 'rake'

  s = Rufus::Scheduler.singleton
  s.every '5m' do
    system('rake sched:dl')
  end
  
  s.every '1d', first: :now do
    puts "\n\+++ *** Checking remote server with rufus scheluler +++ *** \n\n"
    #system('rake sched:dl')
  end

  s.every '2d', first: :now do
    puts "\n+++ *** Backing up downloads directory to raid array +++ *** \n\n"
    #system('./backup.sh')
  end
end