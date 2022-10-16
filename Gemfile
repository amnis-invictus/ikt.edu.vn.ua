source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'bcrypt', '~> 3.1.18'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'dotenv-rails'
gem 'draper'
gem 'hiredis-client'
gem 'image_processing', '~> 1.12'
gem 'jbuilder', '~> 2.11'
gem 'jquery-rails'
gem 'pg', '~> 1.4'
gem 'puma', '~> 5.6'
gem 'pundit'
gem 'rails', '~> 6.1.6'
gem 'rails_admin', '~> 2.0'
gem 'redis', '~> 5.0'
gem 'redis-namespace'
gem 'rubyzip', require: 'zip'
gem 'sassc-rails'
gem 'uglifier'

# Temporarily fix for ruby 3.1
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false

group :development, :test do
  gem 'brakeman'
  gem 'capybara'
  gem 'code-scanning-rubocop'
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'selenium-webdriver'
end

group :development do
  gem 'bullet'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'listen', '~> 3.7'
  gem 'rack-mini-profiler', '~> 3.0'
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
