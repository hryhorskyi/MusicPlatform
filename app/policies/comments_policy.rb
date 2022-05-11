# frozen_string_literal: true

class CommentsPolicy < ApplicationPolicy
  attr_reader :user, :comment

  AVAILABLE_COMMENTS_COUNT_PER_MINUTE = 3

  def initialize(user, comment)
    super
    @comment = comment
  end

  def create?
    (public_playlist? || shared_playlist_owner? || shared_playlist_for_friend?) && too_many_comment_requests?
  end

  private

  def shared_playlist_owner?
    user == comment.playlist.owner && comment.playlist.shared_playlist_type?
  end

  def public_playlist?
    comment.playlist.public_playlist_type?
  end

  def shared_playlist_for_friend?
    comment.playlist.shared_playlist_type? && SharedPlaylistPolicy.new(user, comment.playlist).read?
  end

  def user_comments
    @user_comments ||= comment.playlist.comments.where(user: user).where('created_at > ?', 1.minute.ago)
  end

  def too_many_comment_requests?
    user_comments.size < AVAILABLE_COMMENTS_COUNT_PER_MINUTE
  end
end
