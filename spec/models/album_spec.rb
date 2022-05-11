# frozen_string_literal: true

RSpec.describe Album, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:songs) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    context 'when try to create album with not unique name to single artist' do
      subject(:album) { build(:album, name: album_name, artists: [artist]) }

      let(:artist) { create(:artist) }
      let(:album_name) { 'test' }

      before do
        create(:album, name: album_name, artists: [artist])

        album.validate
      end

      it 'returns correct validation error' do
        expect(album.errors[:name].first).to eq(I18n.t('albums.create.errors.name.is_not_unique'))
      end

      it 'is expected to be invalid' do
        expect(album).not_to be_valid
      end
    end
  end
end
