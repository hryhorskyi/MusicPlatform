# frozen_string_literal: true

class CreateTestUserJob
  include Sidekiq::Job

  def perform
    User.create(email: "test@gmail.com#{rand(1..10_000)}",
                nickname: "test#{rand(1..10_000)}",
                password: 'P@ssw0rd',
                password_confirmation: 'P@ssw0rd')
  end
end
