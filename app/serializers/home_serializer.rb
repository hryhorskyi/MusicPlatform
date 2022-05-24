# frozen_string_literal: true

class HomeSerializer < BaseSerializer
  attribute :top_contributors do |object|
    PublicUserSerializer.new(object.top_contributors)
  end

  attribute :people_with_most_friends do |object|
    PublicUserSerializer.new(object.people_with_most_friends)
  end

  attribute :latest_public_playlists do |object|
    PlaylistSerializer.new(object.latest_public_playlists)
  end

  attribute :most_popular_playlists do |object|
    PlaylistSerializer.new(object.most_popular_playlists)
  end

  attribute :top_featured_public_playlists do |object|
    PlaylistSerializer.new(object.top_featured_public_playlists)
  end

  attribute :top_songs_in_top_genres do |object|
    SongSerializer.new(object.top_songs_in_top_genres)
  end

  attribute :latest_songs do |object|
    SongSerializer.new(object.latest_songs)
  end

  attribute :most_popular_songs do |object|
    SongSerializer.new(object.most_popular_songs)
  end
end
