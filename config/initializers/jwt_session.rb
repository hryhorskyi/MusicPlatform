# frozen_string_literal: true

JWTSessions.algorithm = 'HS256'
JWTSessions.encryption_key = Rails.application.credentials.secret_key_base
JWTSessions.token_store =  :redis, {
  redis_url: ENV.fetch('DOCKER_REDIS_URL',
                       nil) || ENV.fetch('REDIS_URL', Rails.application.credentials.dig(:redis, :url)),
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
}
