# frozen_string_literal: true

namespace :checks do
  desc 'check for pending migrations'
  task db_schema: :environment do
    exit 0 if ENV['CI']

    checker = DevUtils::Lefthook::MigrationConsistencyChecker.new

    exit 0 if checker.passed?
  end

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
