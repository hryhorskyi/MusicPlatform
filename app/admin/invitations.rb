# frozen_string_literal: true

ActiveAdmin.register Invitation do
  permit_params :requestor_id, :receiver_id, :status, :declined_at
  form do |f|
    f.inputs do
      f.input :requestor_id
      f.input :receiver_id
      f.input :status
    end
    f.actions
  end
end
