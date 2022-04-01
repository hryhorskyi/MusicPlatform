# frozen_string_literal: true

ActiveAdmin.register Genre do
  permit_params :name
end
