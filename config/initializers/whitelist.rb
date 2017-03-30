Rails.application.config.home_ip = ENV['HOME_IP']

# a pipe separated string of white listed urls
# url must be exactly as in request.referer
# protocol and trailing / must be present
# ie: https://hello.com/
# or: http://localhost:8000/
# in bashrc or Heroku settings these urls would be 
# export WHITELIST='https://hello.com/|http://localhost:8000/'
Rails.application.config.white_list = ENV['WHITELIST'].split('|')