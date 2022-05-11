# frozen_string_literal: true

class DublicatedAlbumNameOnArtistsScopeQuery
  def initialize(initial_scope = Album.all)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = filter_by_album_name(@initial_scope, params[:album_name])
    scoped = filter_by_artists(scoped, params[:artists])
    filter_by_excluded_ids(scoped, params[:excluded_ids])
  end

  private

  def filter_by_album_name(scope, album_name)
    album_name ? scope.where(name: album_name) : scope
  end

  def filter_by_artists(scope, artists)
    artists ? scope.joins(:album_artists).where(album_artists: { artist_id: artists.map(&:id) }) : scope
  end

  def filter_by_excluded_ids(scope, excluded_ids)
    excluded_ids ? scope.where.not(id: excluded_ids) : scope
  end
end
