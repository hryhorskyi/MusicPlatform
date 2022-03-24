# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApiController
      def create
        @user = User.find_by(email: params[:email]).try(:authenticate, params[:password])
        if @user
          render json: { csrf: SecureRandom.hex(88).to_s,
                         access: SecureRandom.hex(165).to_s,
                         access_expires_at: DateTime.now,
                         refresh: SecureRandom.hex(165).to_s,
                         refresh_expires_at: DateTime.now }, status: :created
        else
          render status: :bad_request
        end
      end

      def destroy
        head :no_content
      end
    end
  end
end
