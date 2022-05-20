# frozen_string_literal: true

require 'active_support/core_ext/integer/time'
require 'shrine/storage/s3'

store = Shrine::Storage::S3.new(
  bucket: Rails.application.credentials.dig(:aws, :bucket),
  region: Rails.application.credentials.dig(:aws, :region),
  access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
  secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
)

Shrine.storages = {
  cache: store,
  store: store
}

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  # config.active_storage.service = :local
  config.force_ssl = ENV['DISABLE_FORCE_SSL'] ? false : true
  config.log_level = :info
  config.log_tags = [:request_id]
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: Rails.application.credentials.dig(:gmail_smtp, :domain),
    user_name: Rails.application.credentials.dig(:gmail_smtp, :email),
    password: Rails.application.credentials.dig(:gmail_smtp, :app_password),
    authentication: 'plain',
    enable_starttls_auto: true,
    open_timeout: 5,
    read_timeout: 5
  }
  config.action_mailer.raise_delivery_errors = true
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.log_formatter = ::Logger::Formatter.new

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false
end
