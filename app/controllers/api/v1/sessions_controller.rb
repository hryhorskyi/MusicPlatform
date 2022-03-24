# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApiController
      def destroy
        head :no_content
      end
    end
  end
end
