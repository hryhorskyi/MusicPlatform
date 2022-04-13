# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      before_action :authorize_access_request!, only: %i[index]

      def index
        result = Users::Index::Organizer.call(current_user: current_user, params: permitted_index_params)
        render json: UserSerializer.new(result.collection), status: :ok
      end

      def create
        @user = User.new(permitted_create_params)
        if @user.save
          head :created
        else
          render_errors(object: @user, status: :unprocessable_entity)
        end
      end

      private

      def permitted_create_params
        params.require(:user).permit(:email, :password, :password_confirmation, :nickname)
      end

      def permitted_index_params
        params.permit(:exclude_friends)
      end
    end
  end
end
