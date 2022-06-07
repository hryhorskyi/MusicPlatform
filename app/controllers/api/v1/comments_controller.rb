# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApiController
      before_action :authorize_user!, only: %i[create]

      def index
        result = Comments::Index::Organizer.call(params: permitted_index_params, current_user: current_user)

        if result.success?
          render json: CommentSerializer.new(result.collection, meta: result.pagination_meta), status: :ok
        else
          render_errors(object: result.model, status: result.error_status)
        end
      end

      def create
        comment = Comments::Create::Organizer.call(params: permitted_create_params, current_user: current_user)

        if comment.success?
          render json: CommentSerializer.new(comment.model, { include: %i[user] }), status: :created
        else
          render_errors(object: comment.model, status: comment.error_status)
        end
      end

      private

      def permitted_index_params
        params.permit(:playlist_id, *PAGINATION_PARAMS)
      end

      def permitted_create_params
        params.require(:comment).permit(:playlist_id, :text)
      end
    end
  end
end
