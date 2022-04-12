# frozen_string_literal: true

module Invitations
  module Create
    class FindExistingInvitation < Common::BaseInteractor
      def call
        context.existing_invitation = current_user_invitations_as_requestor
                                      .or(current_user_invitations_as_receiver)
                                      .order(created_at: :desc)
                                      .first
      end

      private

      def current_user_invitations_as_requestor
        Invitation.where(requestor_id: context.current_user.id, receiver_id: context.params[:receiver_id])
      end

      def current_user_invitations_as_receiver
        Invitation.where(requestor_id: context.params[:receiver_id], receiver_id: context.current_user.id)
      end
    end
  end
end
