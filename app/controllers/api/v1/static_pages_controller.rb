# frozen_string_literal: true

module Api
  module V1
    class StaticPagesController < ApiController
      def show
        page = PageContent.find_by(page_slug: params[:id])

        if page
          render json: StaticPageSerializer.new(page), status: :ok
        else
          render status: :not_found
        end
      end
    end
  end
end
