# frozen_string_literal: true

module Api
  module V1
    class InvitationsController < ApiController
      before_action :authorize_access_request!, only: %i[create index destroy]

      def index
        result = Invitations::Index::Organizer.call(current_user: current_user, params: permitted_index_params)

        render json: InvitationSerializer.new(result.collection.includes(:requestor, :receiver),
                                              { include: %i[receiver requestor] }), status: :ok
      end

      def create
        result = Invitations::Create::Organizer.call(current_user: current_user, params: permitted_create_params)

        if result.success?
          render json: InvitationSerializer.new(result.model), status: :created
        else
          render_errors(object: result.model, status: :unprocessable_entity)
        end
      end

      def destroy
        result = Invitations::Destroy::Organizer.call(current_user: current_user, params: permitted_destroy_params)

        if result.success?
          render status: :no_content
        else
          render status: :not_found
        end
      end

      private

      def permitted_create_params
        params.require(:invitation).permit(:receiver_id)
      end

      def permitted_index_params
        params.permit(:role_filter)
      end

      def permitted_destroy_params
        params.permit(:invitation_id)
      end
    end
  end
end
