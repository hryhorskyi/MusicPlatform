# frozen_string_literal: true

ActiveAdmin.register Song do
  includes :album
  permit_params :name, :featured, :album_id
end
