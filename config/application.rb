# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_text/engine'
# require 'active_storage/engine'
# require 'action_mailbox/engine'
# require "action_cable/engine"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module EpamMusic
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: Rails.application.credentials.cookie_store_key
    config.action_mailer.preview_path = Rails.root.join('spec/mailers/previews')
  end
end
