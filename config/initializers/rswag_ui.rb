# frozen_string_literal: true

Rswag::Ui.configure do |c|
  c.swagger_endpoint '/api-docs/v1/swagger.yaml', 'Epam Music Docs'
  c.swagger_endpoint '/api-docs/v1/swagger_admin.yaml', 'Admin Docs'

  c.basic_auth_enabled = true unless Rails.env.development?
  c.basic_auth_credentials Rails.application.credentials.dig(:rswag, :username),
                           Rails.application.credentials.dig(:rswag, :password)
end
