# frozen_string_literal: true

return if Admin.find_by(email: Rails.application.credentials.dig(:admin, :email))

Admin.create!(email: Rails.application.credentials.dig(:admin, :email),
              password: Rails.application.credentials.dig(:admin, :password),
              password_confirmation: Rails.application.credentials.dig(:admin, :password))
