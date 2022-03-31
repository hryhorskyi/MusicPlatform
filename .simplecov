# frozen_string_literal: true

return if ENV['SIMPLECOV_DISABLE']

SimpleCov.start do
  add_filter %w[vendor spec config app/admin]
  minimum_coverage 95
end
