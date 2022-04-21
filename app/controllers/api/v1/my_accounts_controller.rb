# frozen_string_literal: true

module Api
  module V1
    class MyAccountsController < ApiController
      before_action :authorize_access_request!, only: %i[show update]

      def show
        render json: UserSerializer.new(current_user), status: :ok
      end

      def update
        result = MyAccount::Update::Organizer.call(current_user: current_user, params: permitted_update_params)
        if result.success?
          render json: UserSerializer.new(result.model), status: :ok
        else
          render_errors(object: result.model, status: :unprocessable_entity)
        end
      end

      private

      def permitted_update_params
        params.require(:my_account).permit(:nickname, :first_name, :last_name)
      end
    end
  end
end
