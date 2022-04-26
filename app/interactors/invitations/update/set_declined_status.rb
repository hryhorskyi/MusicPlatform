# frozen_string_literal: true

module Invitations
  module Update
    class SetDeclinedStatus < Common::BaseInteractor
      def call
        context.model[:status] = :declined
        context.model[:declined_at] = Time.zone.now
      end
    end
  end
end
