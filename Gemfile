# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

gem 'rails', '~> 7.0.1'

gem 'activeadmin', '~> 2.11'
gem 'bcrypt', '~> 3.1'
gem 'bootsnap', require: false
gem 'devise', '~> 4.8'
gem 'jsonapi-serializer', '~> 2.2'
gem 'jwt_sessions', '~> 2.7'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'redis', '~> 4.6'
gem 'rswag-api', '~> 2.5'
gem 'rswag-ui', '~> 2.5'
gem 'sass-rails', '~> 6.0'
gem 'sprockets-rails', '~> 3.4', require: 'sprockets/railtie'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'brakeman', '~> 5.2'
  gem 'bullet', '~> 7.0'
  gem 'bundler-audit', '~> 0.9'
  gem 'bundler-leak', '~> 0.2'
  gem 'debug', '~> 1.4', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'ffaker', '~> 2.20'
  gem 'lefthook', '~> 0.7'
  gem 'rubocop', '~> 1.25'
  gem 'rubocop-performance', '~> 1.13'
  gem 'rubocop-rails', '~> 2.13'
  gem 'rubocop-rspec', '~> 2.8', require: false
  gem 'strong_migrations', '~> 0.8'
  gem 'traceroute', '~> 0.8'
end

group :test do
  gem 'json_matchers', '~> 0.11.1'
  gem 'rspec-rails', '~> 5.1'
  gem 'rswag-specs', '~> 2.5'
  gem 'shoulda-matchers', '~> 5.1'
  gem 'simplecov', '~> 0.21', require: false
end
