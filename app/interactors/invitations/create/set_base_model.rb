# frozen_string_literal: true

module Invitations
  module Create
    class SetBaseModel < Common::BaseInteractor
      def call
        context.model = Invitation.new(receiver_id: context.params[:receiver_id], requestor_id: context.current_user.id)
      end
    end
  end
end
