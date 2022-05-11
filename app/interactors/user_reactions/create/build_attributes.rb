# frozen_string_literal: true

module UserReactions
  module Create
    class BuildAttributes < Common::BaseInteractor
      def call
        context.model_params = context.params.merge({ user: context.current_user, playlist: context.playlist })
      end
    end
  end
end
