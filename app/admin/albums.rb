# frozen_string_literal: true

ActiveAdmin.register Album do
  permit_params :name
end
