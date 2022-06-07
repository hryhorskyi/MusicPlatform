# frozen_string_literal: true

module Comments
  module Index
    class SetComments < Common::BaseInteractor
      def call
        context.collection = context.model.comments
      end
    end
  end
end
