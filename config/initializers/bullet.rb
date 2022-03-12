# frozen_string_literal: true

Rails.application.configure do
  if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'

    config.after_initialize do
      Bullet.enable = true
      Bullet.bullet_logger = true
      Bullet.rails_logger = true
      Bullet.raise = true
    end
  end
end
