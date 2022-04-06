# frozen_string_literal: true

module Api
  module V1
    class MyAccountsController < ApiController
      before_action :authorize_access_request!, only: %i[show]

      def show
        render json: UserSerializer.new(current_user), status: :ok
      end
    end
  end
end
