# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      include Authorization
      include JWTSessions::RailsAuthorization
      rescue_from JWTSessions::Errors::Unauthorized do
        render status: :unauthorized
      end

      PAGINATION_PARAMS = %i[after page per_page].freeze
      IMAGE_PARAMS = %i[content original_filename].freeze

      private

      def render_errors(object:, status:)
        if BuildErrors::ERRORS_WITHOUT_BODY.include?(status)
          render status: status
        else
          render json: BuildErrors.call(object, status), status: status
        end
      end
    end
  end
end
