# frozen_string_literal: true

return if ENV['SIMPLECOV_DISABLE']

SimpleCov.start do
  add_filter %w[vendor spec config app/admin lib/dev_utils app/policies/application_policy.rb]
  minimum_coverage 95
end
