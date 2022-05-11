# frozen_string_literal: true

class SharedPlaylistPolicy < ApplicationPolicy
  attr_reader :user, :playlist

  def initialize(user, playlist)
    super
    @playlist = playlist
  end

  def read?
    friendship_with_playlist_owner?
  end

  private

  def friendship_with_playlist_owner?
    user.friends.where(initiator: playlist.owner).or(user.friends.where(acceptor: playlist.owner)).exists?
  end
end
