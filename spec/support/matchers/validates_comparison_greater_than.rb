# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :validates_comparison_other_than do |expected|
  match do |actual|
    actual != expected
  end
end
