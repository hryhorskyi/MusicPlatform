# frozen_string_literal: true

JWTSessions.algorithm = 'HS256'
JWTSessions.encryption_key = Rails.application.credentials.secret_key_base
JWTSessions.token_store =  :redis, {
  redis_host: 'localhost',
  redis_port: '6379',
  redis_db_name: '0',
  token_prefix: 'jwt_'
}
