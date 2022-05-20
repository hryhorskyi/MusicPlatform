# frozen_string_literal: true

require 'shrine'
require 'image_processing/mini_magick'

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :determine_mime_type
Shrine.plugin :store_dimensions, analyzer: :mini_magick
Shrine.plugin :restore_cached_data
Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :derivatives
Shrine.plugin :data_uri
