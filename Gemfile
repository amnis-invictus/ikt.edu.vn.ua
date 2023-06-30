source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'bcrypt', '~> 3.1.19'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'caxlsx'
gem 'connection_pool'
gem 'dotenv-rails'
gem 'draper'
gem 'hiredis'
gem 'image_processing', '~> 1.12'
gem 'jbuilder', '~> 2.11'
gem 'jquery-rails'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.0'
gem 'pundit'
gem 'rails', '~> 6.1.7'
gem 'rails_admin', '~> 2.0'
gem 'redis', '~> 4.8', require: %w[redis redis/connection/hiredis]
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
  gem 'listen', '~> 3.8'
  gem 'rack-mini-profiler', '~> 3.1'
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
