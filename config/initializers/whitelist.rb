Rails.application.config.home_ip = ENV['HOME_IP']
Rails.application.config.white_list = ENV['WHITELIST'].split('|')