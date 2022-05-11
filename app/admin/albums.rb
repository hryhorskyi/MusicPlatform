# frozen_string_literal: true

ActiveAdmin.register Album do
  includes :artists
  permit_params :name, artist_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :artists
    actions
  end

  show do
    attributes_table do
      row :name
      row :artists
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :artists, collection: Artist.all, as: :select
    end
    actions
  end

  controller do
    def update
      album = Album.new(name: params.dig(:album, :name),
                        artists: Artist.where(id: params.dig(:album, :artist_ids)))

      return super if album.valid?

      resource.errors.merge!(album.errors)
      render 'edit'
    end
  end
end
