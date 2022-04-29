# frozen_string_literal: true

ActiveAdmin.register Playlist do
  includes :song
  includes :user_reaction
  includes :comment
  actions :index
end
