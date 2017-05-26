# NOTE: A rails server must be running locally at all times 
# WARNING: not for heroku, the data will be pushed by pgpush after processing

# starts a 'cron' task as per the directives in cron_job
# Rufus Scheduler will execute the code in its block at that time

# set for noon as most archives seem to be done by late morning
cron_hour = 16

cron_job = "00 #{cron_hour} * * 1-5"
#           mm hh               m-f

puts "Starting Cron task. Will check for a new dinesafe archive every weekday at #{cron_hour}pm"

Rufus::Scheduler.new.cron cron_job do
  system('rake sched:dl')
end