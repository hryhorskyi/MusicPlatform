# frozen_string_literal: true

module Pagination
  module Strategies
    class Numeric
      include Pagy::Backend

      attr_reader :paginated, :collection

      def initialize(params)
        @params = params
        @paginated = false
      end

      def paginate(collection)
        @raw_pagination_meta, @collection = pagy(
          collection.order(Pagy::DEFAULT[:default_order]),
          page: page,
          items: params[:per_page].to_i.positive? ? params[:per_page] : Pagy::DEFAULT[:items]
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
          count: raw_pagination_meta.count,
          self: raw_pagination_meta.page,
          next: raw_pagination_meta.next,
          last: raw_pagination_meta.last,
          prev: raw_pagination_meta.prev
        }
      end

      private

      attr_reader :params, :raw_pagination_meta

      def page
        Integer(params[Pagy::DEFAULT[:page_param]], exception: false) || Pagy::DEFAULT[:page]
      end
    end
  end
end
