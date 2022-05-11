# frozen_string_literal: true

RSpec.describe DublicatedAlbumNameOnArtistsScopeQuery do
  describe '#call' do
    subject(:result) { described_class.new.call(params) }

    let(:album) { create(:album, artists: artists_list) }
    let(:artists_list) { [create(:artist)] }

    context 'when call with empty params' do
      let(:params) { {} }

      it 'returns all albums' do
        expect(result).to eq([album])
      end
    end

    context 'when call with excluded_ids param' do
      let(:params) { { excluded_ids: [album.id] } }
      let(:album1) { create(:album) }

      it 'returns all albums without excluded album' do
        expect(result).to eq([album1])
      end
    end

    context 'when call with album_name param' do
      let(:album1) { create(:album, name: album.name) }
      let(:params) { { album_name: album.name } }

      it 'returns albums with required name' do
        expect(result).to eq([album, album1])
      end
    end

    context 'when call with artists param' do
      let(:album1) { create(:album, artists: artists_list) }
      let(:params) { { artists: artists_list } }

      it 'returns albums with required artist' do
        expect(result).to eq([album, album1])
      end
    end

    context 'when call with dublicate values' do
      let(:params) { { album_name: album.name, artists: artists_list } }

      it 'returns album with same attributes' do
        expect(result).to eq([album])
      end
    end

    context 'when call with not dublicate values' do
      let(:params) { { album_name: album.name, artists: artists_list, excluded_ids: [album.id] } }

      it 'returns empty array' do
        expect(result).to eq([])
      end
    end
  end
end
