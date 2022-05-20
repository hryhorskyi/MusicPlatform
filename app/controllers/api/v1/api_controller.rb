# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      include JWTSessions::RailsAuthorization
      rescue_from JWTSessions::Errors::Unauthorized do
        render status: :unauthorized
      end

      PAGINATION_PARAMS = %i[after page per_page].freeze
      IMAGE_PARAMS = %i[content original_filename].freeze

      private

      def current_user
        return @current_user if @current_user

        @current_user = User.find_by(id: payload['user_id'])
        raise JWTSessions::Errors::Unauthorized, status: :unauthorized if @current_user.blank?

        @current_user
      end

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
