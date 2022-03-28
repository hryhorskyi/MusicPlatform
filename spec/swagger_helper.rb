# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      swagger: '2.0',
      info: {
        title: 'Epam Music',
        version: 'v1'
      },
      paths: {},
      servers: [
        { url: 'http://{host}', variables: { host: { default: Rails.application.credentials.dig(:rswag, :host) } } }
      ]
    },
    'v1/swagger_admin.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Documentation for admin users',
        version: 'v1'
      },
      paths: {}
    }
  }
  config.swagger_format = :yaml
end
