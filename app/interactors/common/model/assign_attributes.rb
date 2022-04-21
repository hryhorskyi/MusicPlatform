# frozen_string_literal: true

module Common
  module Model
    class AssignAttributes < Common::BaseInteractor
      def call
        context.model.assign_attributes(context.params)
      end
    end
  end
end
