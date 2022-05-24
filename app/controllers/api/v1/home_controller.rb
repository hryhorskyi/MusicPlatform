# frozen_string_literal: true

module Api
  module V1
    class HomeController < ApiController
      def index
        result = Home::Index::Organizer.call

        render json: HomeSerializer.new(result.model), status: :ok
      end
    end
  end
end
