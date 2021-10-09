source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'dotenv-rails'
gem 'draper'
gem 'hiredis'
gem 'image_processing', '~> 1.2'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
gem 'rails_admin', '~> 2.0'
gem 'redis', '~> 4.0', require: %w[redis redis/connection/hiredis]
gem 'redis-namespace'
gem 'sassc-rails'
gem 'simple_form'
gem 'uglifier'

group :development, :test do
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'bullet'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
