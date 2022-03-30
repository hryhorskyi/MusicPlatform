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
        session = SessionUpdate.call(token_from_headers(:refresh))
        render json: session, status: :ok
      end

      def destroy
        SessionDestroy.call(token_from_headers(:refresh))
        head :no_content
      end
    end
  end
end
