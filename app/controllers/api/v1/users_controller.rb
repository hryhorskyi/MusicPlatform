# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      def create
        @user = User.new(permitted_params)
        if @user.save
          head :created
        else
          render_errors(object: @user, status: :unprocessable_entity)
        end
      end

      private

      def permitted_params
        params.require(:user).permit(:email, :password, :password_confirmation, :nickname)
      end
    end
  end
end
