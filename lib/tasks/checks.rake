# frozen_string_literal: true

namespace :checks do
  desc 'Rake task for check the schemas of credentials'
  task credentials: :environment do
    exit 0 if ENV['CI']

    checker = DevUtils::Lefthook::CredentialsStructureChecker.new
    checker.call

    exit 0 if checker.errors.blank?

    puts checker.errors
    exit 1
  end
end
