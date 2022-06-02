# frozen_string_literal: true

module Friends
  module Destroy
    class FindFriendship < Common::BaseInteractor
      def call
        context.model = context.current_user.friends.find_by(id: context.params[:id])
        return if context.model.present?

        context.fail!(error_status: :forbidden)
      end
    end
  end
end
