# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

gem 'rails', '~> 7.0.1'

gem 'activeadmin', '~> 2.11'
gem 'ar_lazy_preload', '~> 1.0'
gem 'bcrypt', '~> 3.1'
gem 'bootsnap', require: false
gem 'devise', '~> 4.8'
gem 'hamlit', '~> 2.16'
gem 'interactor', '~> 3.1'
gem 'jsonapi-serializer', '~> 2.2'
gem 'jwt_sessions', '~> 2.7'
gem 'letter_opener', '~> 1.4'
gem 'pagy', '~> 5.10'
gem 'pagy_cursor', '~> 0.5'
gem 'pg', '~> 1.3'
gem 'puma', '~> 5.0'
gem 'redis', '~> 4.6'
gem 'rswag-api', '~> 2.5'
gem 'rswag-ui', '~> 2.5'
gem 'sass-rails', '~> 6.0'
gem 'seedbank', '~> 0.5'
gem 'sentry-rails', '~> 5.3'
gem 'sentry-ruby', '~> 5.3'
gem 'sidekiq', '~> 6.4'
gem 'sprockets-rails', '~> 3.4', require: 'sprockets/railtie'
gem 'strong_migrations', '~> 1.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'brakeman', '~> 5.2'
  gem 'bundler-audit', '~> 0.9'
  gem 'bundler-leak', github: 'Quitehours/bundler-leak', branch: 'main'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'ffaker', '~> 2.21'
  gem 'lefthook', '~> 0.7'
  gem 'pry', '~> 0.14'
  gem 'rubocop', '~> 1.27'
  gem 'rubocop-performance', '~> 1.13'
  gem 'rubocop-rails', '~> 2.13'
  gem 'rubocop-rspec', '~> 2.8', require: false
  gem 'traceroute', '~> 0.8'
end

group :test do
  gem 'json_matchers', '~> 0.11'
  gem 'n_plus_one_control', '~> 0.6'
  gem 'rspec-rails', '~> 5.1'
  gem 'rswag-specs', '~> 2.5'
  gem 'shoulda-matchers', '~> 5.1'
  gem 'simplecov', '~> 0.21', require: false
end
