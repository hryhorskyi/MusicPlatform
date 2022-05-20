# frozen_string_literal: true

class AvatarUploader < Shrine
  AVATAR_MAX_SIZE = 5.megabytes
  AVATAR_TYPES = %w[image/jpeg image/png image/webp].freeze
  SMALL_AVATAR_DIMENSIONS = [300, 300].freeze
  MEDIUM_AVATAR_DIMENSIONS = [500, 500].freeze
  LARGE_AVATAR_DIMENSIONS = [800, 800].freeze

  Attacher.validate do
    validate_mime_type AVATAR_TYPES
    validate_max_size AVATAR_MAX_SIZE, message: I18n.t('my_account.update.errors.avatar_size', count: AVATAR_MAX_SIZE)

    false unless errors.empty?
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    {
      small: magick.resize_to_limit!(*SMALL_AVATAR_DIMENSIONS),
      medium: magick.resize_to_limit!(*MEDIUM_AVATAR_DIMENSIONS),
      large: magick.resize_to_limit!(*LARGE_AVATAR_DIMENSIONS)
    }
  end
end
