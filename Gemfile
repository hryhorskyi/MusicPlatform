# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

gem 'rails', '~> 7.0.1'

gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'brakeman', '~> 5.2'
  gem 'bundler-audit', '~> 0.9'
  gem 'bundler-leak', '~> 0.2'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'lefthook', '~> 0.7'
  gem 'rubocop', '~> 1.25'
  gem 'rubocop-performance', '~> 1.13'
  gem 'rubocop-rails', '~> 2.13'
  gem 'strong_migrations', '~> 0.8'
  gem 'traceroute', '~> 0.8'
end
