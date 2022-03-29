# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApiController
      def create
        user = User.find_by(email: params[:email]).try(:authenticate, params[:password])

        if user
          tokens = SessionCreate.call(user.id)
          render json: tokens, status: :created
        else
          render status: :bad_request
        end
      end

      def update
        render json: { csrf: SecureRandom.hex(88).to_s,
                       access: SecureRandom.hex(165).to_s,
                       access_expires_at: DateTime.now }, status: :ok
      end

      def destroy
        SessionDestroy.call(token_from_headers(:refresh))
        head :no_content
      end
    end
  end
end
