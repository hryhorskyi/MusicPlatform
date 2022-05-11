# frozen_string_literal: true

ActiveAdmin.register Playlist do
  includes :songs
  includes :user_reactions
  includes :comments
  actions :index
end
