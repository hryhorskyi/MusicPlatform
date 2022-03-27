# frozen_string_literal: true

class BaseSerializer
  include JSONAPI::Serializer

  DATE_TIME_FORMAT = '%Y-%m-%d %H:%M:%S'
end
