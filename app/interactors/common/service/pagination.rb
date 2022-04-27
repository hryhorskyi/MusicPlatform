# frozen_string_literal: true

module Common
  module Service
    class Pagination < Common::BaseInteractor
      def call
        strategy = context.params[:after] ? cursor_strategy : numeric_strategy

        strategy.paginate(context.collection)

        context.collection = strategy.paginated_collection
        context.pagination_meta = strategy.pagination_meta
      end

      private

      def cursor_strategy
        ::Pagination::Strategies::Cursor.new(context.params.slice(:after, :per_page))
      end

      def numeric_strategy
        ::Pagination::Strategies::Numeric.new(context.params.slice(:page, :per_page))
      end
    end
  end
end
