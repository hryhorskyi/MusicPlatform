# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  track_files 'app/**/*.rb'
  add_filter %w[spec config]
  minimum_coverage 95
end
