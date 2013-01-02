source :rubygems
#source 'http://rubygems.torquebox.org'


gem 'bundler'
gem 'rake'
gem "sinatra"
gem "sinatra-reloader"
gem "rack-flash"

# odd, but this is required by monkey-lib which is required by rack session
# cookies, but doesn't get installed unless we're explicit about it
gem "extlib" 

gem 'haml', '~>3.0'
gem 'sass', '~>3.1'
gem 'json_pure'
gem 'state_machine'
gem 'git'

gem 'data_mapper'
gem 'dm-core'
gem 'dm-postgres-adapter'
gem 'dm-migrations'
gem 'dm-timestamps'
gem 'dm-observer'

gem 'torquebox'
gem "thor"

group :development do
  gem 'jeweler'
end

group :test do
  gem 'rspec', :require => 'spec'
  gem 'rack-test'
  #gem 'sqlite3'
  gem 'dm-sqlite-adapter'
  gem 'torquespec'
  gem 'capybara'
  gem 'akephalos'
end
  
