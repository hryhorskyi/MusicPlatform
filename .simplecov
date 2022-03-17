# frozen_string_literal: true

SimpleCov.start do
  add_filter %w[vendor spec config]
  minimum_coverage 95
end
