# frozen_string_literal: true

module Pagination
  module Strategies
    class Cursor
      include Pagy::Backend

      attr_reader :paginated, :collection

      def initialize(params)
        @params = params
        @paginated = false
      end

      def paginate(collection)
        @raw_pagination_meta, @collection = pagy_uuid_cursor(
          collection,
          after: params[:after],
          items: params[:per_page].to_i.positive? ? params[:per_page] : Pagy::DEFAULT[:items],
          order: Pagy::DEFAULT[:default_order]
        )

        @paginated = true
      end

      def paginated_collection
        raise Errors::NotPaginatedYetError unless paginated

        collection
      end

      def pagination_meta
        raise Errors::NotPaginatedYetError unless paginated

        {
          per_page: raw_pagination_meta.items,
          max_per_page: Pagy::DEFAULT[:max_items],
          comparation: raw_pagination_meta.comparation,
          after: raw_pagination_meta.after,
          next: collection.last&.id,
          has_more: raw_pagination_meta.has_more
        }
      end

      private

      attr_reader :params, :raw_pagination_meta
    end
  end
end
