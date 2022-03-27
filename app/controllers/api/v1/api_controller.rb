# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      private

      def render_errors(object:, status:)
        render json: BuildErrors.call(object, status), status: status
      end
    end
  end
end
