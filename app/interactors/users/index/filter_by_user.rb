# frozen_string_literal: true

module Users
  module Index
    class FilterByUser < Common::BaseInteractor
      def call
        context.collection = context.collection.where.not(id: context.current_user.id)
      end
    end
  end
end
