# frozen_string_literal: true

RSpec.describe PlaylistSongsPolicy, type: :policy do
  subject(:result) { described_class.new(user, playlist_songs) }

  let(:user) { create(:user) }
  let(:playlist_songs) { create(:playlist_song, playlist: playlist, song: song, user: user) }
  let(:song) { create(:song) }
  let(:playlist) { create(:playlist, :public, owner: user) }

  context 'when user is playlist owner' do
    it { is_expected.to permit(:create) }
  end

  context 'when playlist is shared' do
    let(:playlist) { create(:playlist, :shared, owner: user) }

    it { is_expected.to permit(:create) }
  end

  context 'when playlist is private' do
    let(:playlist) { create(:playlist, :private, owner: user) }

    it { is_expected.to permit(:create) }
  end

  context 'when user is friend of playlist owner and playlist is shared' do
    before do
      create(:friend, initiator: user, acceptor: playlist.owner)
    end

    let(:playlist) { create(:playlist, :shared) }

    it { is_expected.to permit(:create) }
  end

  context 'when user is friend of playlist owner and playlist is private' do
    before do
      create(:friend, initiator: user, acceptor: playlist.owner)
    end

    let(:playlist) { create(:playlist, :private) }

    it { is_expected.not_to permit(:create) }
  end

  context 'when user is not owner' do
    let(:playlist) { create(:playlist, :public) }

    it { is_expected.not_to permit(:create) }
  end
end
