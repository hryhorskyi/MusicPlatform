# frozen_string_literal: true

module Users
  module Destroy
    class Organizer < Common::BaseOrganizer
      organize  Initialize,
                FindUser,
                Common::Policy::Check,
                Common::Model::Delete
    end
  end
end
