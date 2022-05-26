# frozen_string_literal: true

RSpec.describe PlaylistSongs::Create::BuildAttributes do
  describe '.call' do
    subject(:result) { described_class.call(current_user: current_user, params: params) }

    context 'when a model_params assigned correctly' do
      let(:current_user) { create(:user) }
      let(:song) { create(:song) }
      let(:params) { { song_id: song.id, playlist_id: playlist.id } }
      let(:playlist) { create(:playlist) }

      it 'has success result' do
        expect(result).to be_success
      end

      it 'has assigned model_params' do
        expect(result.model_params).to eq(params.merge({ user: current_user, playlist_id: params[:playlist_id],
                                                         song_id: params[:song_id] }))
      end
    end
  end
end
