# frozen_string_literal: true

ActiveAdmin.register Artist do
  permit_params :name
end
