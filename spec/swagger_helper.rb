# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Epam Music',
        version: 'v1'
      },
      paths: {},
      servers: [
        { url: 'http://{defaultHost}', variables: { defaultHost: { default: 'localhost:3000' } } }
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
