# NOTE: A rails server must be running locally at all times 
# `rails s &` for background operation 

# WARNING: not for heroku, the data will be pushed by pgpush after processing
 
s = Rufus::Scheduler.new

s.every '1d', first: :now do
  puts '*** Checking remote server with rufus scheluler....'
  #system('rake sched:dl')
end

s.every '2d', first: :now do
  puts 'Backing up downloads directory to raid array...'
  #system('./backup.sh')
end
