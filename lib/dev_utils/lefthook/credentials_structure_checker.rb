# frozen_string_literal: true

require 'yaml'

module DevUtils
  module Lefthook
    class CredentialsStructureChecker
      DEFAULT_ENVIRONMENTS = %w[test development staging production].freeze
      DEFAULT_SCHEMA_PATH = 'config/credentials_example.yaml'
      ENV_KEY = 'RAILS_MASTER_KEY'

      attr_reader :errors

      def initialize
        @errors = []
      end

      def call
        DEFAULT_ENVIRONMENTS.each do |env|
          credentials = decrypted_credentials(env)
          current_schema_keys = convert_hash_keys_to_array(credentials)

          next if current_schema_keys == default_schema_keys

          @errors << "Default schema credentials example not equal with #{env} schema credentials!"
        end
      rescue ActiveSupport::MessageEncryptor::InvalidMessage,
             ActiveSupport::EncryptedFile::MissingKeyError,
             Errno::ENOENT => e

        @errors.push(e.message)
      end

      private

      def default_schema_keys
        @default_schema_keys ||= convert_hash_keys_to_array(default_schema).map(&:to_sym)
      end

      def decrypted_credentials(environment)
        credentials = ActiveSupport::EncryptedConfiguration.new(
          config_path: Rails.root.join("config/credentials/#{environment}.yml.enc"),
          key_path: Rails.root.join("config/credentials/#{environment}.key"),
          env_key: ENV_KEY,
          raise_if_missing_key: true
        )

        credentials.config
      end

      def convert_hash_keys_to_array(hash)
        hash.each_with_object([]) do |(key, value), keys|
          keys << key
          keys.concat(convert_hash_keys_to_array(value)) if value.is_a? Hash
        end
      end

      def default_schema
        @default_schema ||= YAML.load(File.read(Rails.root.join(DEFAULT_SCHEMA_PATH)))
      end
    end
  end
end
