# frozen_string_literal: true

module Api
  module V1
    class InvitationsController < ApiController
      before_action :authorize_access_request!, only: %i[create]

      def create
        result = Invitations::Create::Organizer.call(current_user: current_user, params: permitted_params)

        if result.success?
          render json: InvitationSerializer.new(result.model), status: :created
        else
          render_errors(object: result.model, status: :unprocessable_entity)
        end
      end

      private

      def permitted_params
        params.require(:invitation).permit(:receiver_id)
      end
    end
  end
end
