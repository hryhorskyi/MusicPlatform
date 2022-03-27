# frozen_string_literal: true

class BuildErrors
  class << self
    def call(object, status)
      { errors: json_errors(object, status) }
    end

    private

    def json_errors(object, status)
      object.errors.messages.flat_map do |field, errors_messages|
        errors_messages.map do |error_message|
          {
            status: Rack::Utils.status_code(status),
            title: field.to_s.capitalize,
            source: { pointer: "/data/attributes/#{field}" },
            detail: "#{field.to_s.capitalize} #{error_message}"
          }
        end
      end
    end
  end
end
