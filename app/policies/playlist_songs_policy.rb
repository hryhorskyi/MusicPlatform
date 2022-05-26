# frozen_string_literal: true

class PlaylistSongsPolicy < ApplicationPolicy
  attr_reader :user, :playlist_song

  def initialize(user, playlist_song)
    super
    @playlist_song = playlist_song
  end

  def create?
    playlist_owner? || shared_playlist_for_friend?
  end

  private

  def playlist_owner?
    user == playlist_song.playlist.owner
  end

  def shared_playlist_for_friend?
    playlist_song.playlist.shared_playlist_type? && SharedPlaylistPolicy.new(user, playlist_song.playlist).read?
  end
end
