source 'https://rubygems.org'

gem 'sinatra'

gem 'sinatra-contrib'
gem 'rack-flash3'

gem 'thin'

gem 'dm-core'

gem 'dm-aggregates'
gem 'dm-constraints'
gem 'dm-migrations'
gem 'dm-timestamps'
gem 'dm-transactions'
gem 'dm-validations'

gem 'rake'
gem 'pry'

gem 'scrypt'

group :heroku do
  gem 'dm-postgres-adapter'
end

group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-rspec'

  gem 'capybara'
  gem 'coveralls'
  gem 'database_cleaner'
  gem 'dm-rspec'
  gem 'dm-sqlite-adapter'
  gem 'fabrication'
  gem 'faker'
  gem 'rspec'
  gem 'simplecov'

  # Not a big fan of this module, it's a pretty dirty hack and relatively slow
  # for testing. But it does work and allows me to actually inspect application
  # state from functional tests.
  gem 'rack_session_access'

  gem 'rdoc'
  gem 'redcarpet'
  gem 'yard'
end
