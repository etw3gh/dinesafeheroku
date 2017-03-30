# Provides a layer of security for all incoming requests

# Set values in both .bashrc and Heroku settings

# Set HOME_IP to your testing machine
# Set WHITELIST to any deployed site that calls this rails API

# If no referer is detected, only your home ip will be allowed access to the controllers
# Otherwise, the referer must be on your whitelist as defined below
Rails.application.config.home_ip = ENV['HOME_IP']

# a pipe separated string of white listed urls
# url must be exactly as in request.referer
# protocol and trailing / must be present
# ie: https://hello.com/
# or: http://localhost:8000/
# in bashrc or Heroku settings these urls would be 
# export WHITELIST='https://hello.com/|http://localhost:8000/'
Rails.application.config.white_list = ENV['WHITELIST'].split('|')