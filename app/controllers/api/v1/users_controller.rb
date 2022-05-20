# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      before_action :authorize_access_request!, only: %i[index destroy]

      def index
        result = Users::Index::Organizer.call(current_user: current_user, params: permitted_index_params)
        render json: UserSerializer.new(result.collection, meta: result.pagination_meta), status: :ok
      end

      def create
        result = Users::Create::Organizer.call(params: permitted_create_params)
        if result.success?
          head :created
        else
          render_errors(object: result.model, status: :unprocessable_entity)
        end
      end

      def destroy
        result = Users::Destroy::Organizer.call(current_user: current_user, params: permitted_destroy_params)

        if result.success?
          render status: :no_content
        else
          render_errors(object: result.model, status: result.error_status)
        end
      end

      private

      def permitted_create_params
        params.require(:user).permit(:email, :password, :password_confirmation, :nickname)
      end

      def permitted_index_params
        params.permit(:exclude_friends, :email_filter, *PAGINATION_PARAMS)
      end

      def permitted_destroy_params
        params.permit(:id)
      end
    end
  end
end
