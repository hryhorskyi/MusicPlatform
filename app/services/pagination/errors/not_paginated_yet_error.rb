# frozen_string_literal: true

module Pagination
  module Errors
    class NotPaginatedYetError < StandardError
      def message
        I18n.t('services.pagination.errors.not_paginated_yet_error')
      end
    end
  end
end
