# frozen_string_literal: true

Rails.application.configure do
  if Rails.env.development? || Rails.env.test?

    config.after_initialize do
      StrongMigrations.start_after = 20_220_221_122_958
      StrongMigrations.lock_timeout = 10.seconds
      StrongMigrations.statement_timeout = 1.hour
      StrongMigrations.auto_analyze = true
    end
  end
end
