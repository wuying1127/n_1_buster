class Artist < ActiveRecord::Base
  has_many(
    :albums,
    class_name: "Album",
    foreign_key: :artist_id,
    primary_key: :id
  )

  def n_plus_one_tracks
    albums = self.albums
    tracks_count = {}
    albums.each do |album|
      tracks_count[album.title] = album.tracks.length
    end

    tracks_count
  end

  def better_tracks_query
    albums = self
      .albums
      .select("albums.*, COUNT(*) AS tracks_count")
      .joins(:tracks)
      .group("albums.id")

    albums_tracks_count = {}
    albums.map do |album|
      albums_tracks_count[album.title] = album.tracks.length
    end

    albums_tracks_count
  end
end
