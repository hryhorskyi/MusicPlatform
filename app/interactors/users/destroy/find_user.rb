# frozen_string_literal: true

module Users
  module Destroy
    class FindUser < Common::BaseInteractor
      def call
        context.model = User.find_by(id: context.params[:id])
        return if context.model.present?

        context.fail!(error_status: :bad_request)
      end
    end
  end
end
