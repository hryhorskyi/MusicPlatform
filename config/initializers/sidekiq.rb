# frozen_string_literal: true

require 'sidekiq/api'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', Rails.application.credentials.dig(:sidekiq, :server_url)) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', Rails.application.credentials.dig(:sidekiq, :client_url)) }
end
