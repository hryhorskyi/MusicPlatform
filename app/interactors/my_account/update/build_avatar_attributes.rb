# frozen_string_literal: true

module MyAccount
  module Update
    class BuildAvatarAttributes < Common::BaseInteractor
      def call
        return unless context.params[:avatar]

        context.params_for_validation[:avatar] = build_avatar
        context.params[:avatar] = build_avatar
      end

      private

      def build_avatar
        ShrineImageBuilder.call(image: context.params[:avatar][:content],
                                filename: context.params[:avatar][:original_filename])
      end
    end
  end
end
