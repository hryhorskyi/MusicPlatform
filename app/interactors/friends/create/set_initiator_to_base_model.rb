# frozen_string_literal: true

module Friends
  module Create
    class SetInitiatorToBaseModel < Common::BaseInteractor
      def call
        context.model.initiator_id = context.invitation.requestor_id
      end
    end
  end
end
