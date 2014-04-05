source 'https://rubygems.org'
ruby '2.0.0'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt-ruby'
gem 'bootstrap_form'
gem 'fabrication'
gem 'faker'
gem 'sidekiq'
gem 'unicorn'
gem 'sinatra', require: false
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'
gem 'stripe'
gem 'draper', '~> 1.3'
gem 'stripe_event'

group :development do
  gem 'sqlite3'
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :development, :test  do
  gem 'rspec-rails', '~> 3.0.0.beta'
  gem 'rspec-collection_matchers'
  gem 'pry'
  gem 'pry-nav'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'vcr'
  gem 'webmock', '~> 1.15.2'
  gem 'selenium-webdriver'
  gem 'capybara-webkit'
  gem 'database_cleaner'
end