# frozen_string_literal: true

module DevUtils
  module Lefthook
    class MigrationConsistencyChecker
      DATE_REGEXP = /\d{4}_\d{1,2}_\d{1,2}_\d{1,6}/

      attr_reader :errors

      def initialize
        @errors = []
      end

      def passed?
        pending_migration? && version_in_schema_database? && non_index_migration? && version_in_schema_rb?
      end

      private

      def pending_migration?
        ActiveRecord::Migration.check_pending!
        true
      rescue ActiveRecord::PendingMigrationError => e
        errors << e.message
        false
      end

      def version_in_schema_database?
        current_version = ActiveRecord::Migrator.current_version.to_s
        return true if current_version == date_last_migration

        errors << 'Version of your schema in database is not equal to the last migration'
        false
      end

      def non_index_migration?
        migrations_check = `git ls-files -o  --exclude-standard | grep 'db\/migrate\/20[0-9]*'`

        return true if migrations_check.blank?

        errors << <<-WARNING_MESSAGE

              You have migrations that have not been added to git index.

              Add your migrations to index and try again

        WARNING_MESSAGE
        false
      end

      def version_in_schema_rb?
        file = File.read(Rails.root.join('db/schema.rb'))
        version_schema = file.scan(DATE_REGEXP)
        date_from_version_schema = version_schema[0].delete('_')
        return true if date_from_version_schema == date_last_migration

        errors << 'Version of your schema.rb is not equal to the last migration'
        false
      end

      def date_last_migration
        Dir.glob(Rails.root.join('db/migrate/*.rb')).map do |migration_file|
          migration_file.gsub(/[^\d]/, '')
        end.last
      end
    end
  end
end
