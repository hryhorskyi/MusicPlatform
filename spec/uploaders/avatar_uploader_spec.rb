# frozen_string_literal: true

RSpec.describe AvatarUploader do
  let(:avatar) { user.avatar }
  let(:derivatives) { user.avatar_derivatives! }
  let(:user) { create(:user, :with_avatar) }

  context 'when extracts metadata' do
    it 'has correct mime_type' do
      expect(AvatarUploader::AVATAR_TYPES).to include(avatar.mime_type)
    end

    it 'has correct extension' do
      expect(avatar.extension).to eq('png')
    end

    it 'has correct size' do
      expect(avatar.size).to be < AvatarUploader::AVATAR_MAX_SIZE.megabytes
    end

    it 'has width' do
      expect(avatar.width).to be_instance_of(Integer)
    end

    it 'has height' do
      expect(avatar.height).to be_instance_of(Integer)
    end
  end

  context 'when generates derivatives' do
    it 'has small derivative' do
      expect(derivatives[:small]).to be_kind_of(Shrine::UploadedFile)
    end

    it 'has medium derivative' do
      expect(derivatives[:medium]).to be_kind_of(Shrine::UploadedFile)
    end

    it 'has large derivative' do
      expect(derivatives[:large]).to be_kind_of(Shrine::UploadedFile)
    end
  end

  context 'when derivatives has correct size' do
    it 'small image has correct size' do
      expect(derivatives[:small].dimensions).to eq(AvatarUploader::SMALL_AVATAR_DIMENSIONS)
    end

    it 'medium image has correct size' do
      expect(derivatives[:medium].dimensions).to eq(AvatarUploader::MEDIUM_AVATAR_DIMENSIONS)
    end

    it 'large image has correct size' do
      expect(derivatives[:large].dimensions).to eq(AvatarUploader::LARGE_AVATAR_DIMENSIONS)
    end
  end
end
