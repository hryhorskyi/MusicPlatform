# frozen_string_literal: true

class CommentsIndexPolicy < ApplicationPolicy
  attr_reader :user, :playlist

  def initialize(user, playlist)
    super
    @playlist = playlist
  end

  def index?
    public_playlist? || shared_playlist_owner? || shared_playlist_for_friend?
  end

  private

  def public_playlist?
    playlist.public_playlist_type?
  end

  def shared_playlist_owner?
    return false unless user

    user == playlist.owner && playlist.shared_playlist_type?
  end

  def shared_playlist_for_friend?
    return false unless user

    playlist.shared_playlist_type? && SharedPlaylistPolicy.new(user, playlist).read?
  end
end
