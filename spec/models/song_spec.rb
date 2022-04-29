# frozen_string_literal: true

RSpec.describe Song, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:featured).of_type(:boolean).with_options(null: false) }
    it { is_expected.to have_db_column(:album_id).of_type(:uuid) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:album) }
    it { is_expected.to have_many(:playlist_songs).dependent(:destroy) }
    it { is_expected.to have_many(:song_artists) }
    it { is_expected.to have_many(:artists).through(:song_artists) }
    it { is_expected.to have_many(:song_genres) }
    it { is_expected.to have_many(:genres).through(:song_genres) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to allow_value(%w[true false]).for(:featured) }
  end
end
