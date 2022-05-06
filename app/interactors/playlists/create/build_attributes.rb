# frozen_string_literal: true

module Playlists
  module Create
    class BuildAttributes < Common::BaseInteractor
      def call
        context.model_params = context.params.merge({ owner: context.current_user })
      end
    end
  end
end
