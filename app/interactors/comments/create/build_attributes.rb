# frozen_string_literal: true

module Comments
  module Create
    class BuildAttributes < Common::BaseInteractor
      def call
        context.model_params = context.params.merge({ user: context.current_user,
                                                      text: context.params[:text]&.strip,
                                                      playlist: context.playlist })
      end
    end
  end
end
