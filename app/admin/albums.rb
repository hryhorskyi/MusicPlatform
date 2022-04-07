# frozen_string_literal: true

ActiveAdmin.register Album do
  includes :artist
  permit_params :name, :artist_id
end
