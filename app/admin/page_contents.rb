# frozen_string_literal: true

ActiveAdmin.register PageContent do
  permit_params :page_slug, :content

  form do |f|
    f.inputs do
      f.input :page_slug
      li do
        label :content
        f.rich_text_area :content
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :page_slug
      row :content do
        div resource.content
      end
    end
  end
end
