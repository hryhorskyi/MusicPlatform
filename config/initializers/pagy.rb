# frozen_string_literal: true

require 'pagy/extras/items'
require 'pagy/extras/overflow'
require 'pagy_cursor/pagy/extras/cursor'
require 'pagy_cursor/pagy/extras/uuid_cursor'

Pagy::DEFAULT[:items_param] = :per_page
Pagy::DEFAULT[:items] = 20
Pagy::DEFAULT[:max_items] = 25

Pagy::DEFAULT[:page_param] = :page
Pagy::DEFAULT[:page] = 1

Pagy::DEFAULT[:default_order] = { created_at: :asc }
