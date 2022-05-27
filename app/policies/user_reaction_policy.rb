# frozen_string_literal: true

class UserReactionPolicy < ApplicationPolicy
  attr_reader :user, :user_reaction

  def initialize(user, user_reaction)
    super
    @user_reaction = user_reaction
  end

  def create?
    not_playlist_owner? && (public_playlist? || shared_playlist_for_friend?)
  end

  def update?
    user == user_reaction.user
  end

  def destroy?
    user == user_reaction.user
  end

  private

  def not_playlist_owner?
    user != user_reaction.playlist.owner
  end

  def public_playlist?
    user_reaction.playlist.public_playlist_type?
  end

  def shared_playlist_for_friend?
    user_reaction.playlist.shared_playlist_type? && SharedPlaylistPolicy.new(user, user_reaction.playlist).read?
  end
end
