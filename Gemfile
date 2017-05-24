source 'https://rubygems.org'
gem 'rails', '~> 5.0.0'

# Use postgresql as the database for Active Record
# This is pushed to the app from a local server
# DB is read only 
gem 'pg', '~> 0.18'

gem 'brakeman', :require => false

# Use mongo for user settings and modifications
gem 'mongo', '~> 2.4'

gem 'puma', '~> 3.0'

# some views exist....
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'

# https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

gem 'pry-rails', :group => :development

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'nokogiri'

# wont be needed until we go beyond Toronto....
# gem 'mechanize'

# for auto downloads (getting rid of python web service)
gem 'rufus-scheduler'

# for file downloads
gem 'faraday'

gem 'acts_as_singleton', '~> 0.0.8'

# https://github.com/forgecrafted/finishing_moves
# for numeric? and possibly more...
gem 'finishing_moves'

gem 'rack-cors'
ruby '2.2.2'