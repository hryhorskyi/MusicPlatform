# frozen_string_literal: true

module Users
  module Index
    class FilterByEmail < Common::BaseInteractor
      def call
        return if context.params[:email_filter].blank?

        context.collection = context.collection.where('users.email ILIKE ?', "%#{context.params[:email_filter]}%")
      end
    end
  end
end
