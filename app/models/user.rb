# frozen_string_literal: true

class User < ApplicationRecord
  include EmailValidations
  include PasswordValidations

  has_many :received_invitations,
           class_name: 'Invitation',
           foreign_key: 'receiver_id',
           inverse_of: :receiver,
           dependent: :destroy

  has_many :sent_invitations,
           class_name: 'Invitation',
           foreign_key: 'requestor_id',
           inverse_of: :requestor,
           dependent: :destroy

  has_many :initiated_friendships,
           class_name: 'Friend',
           foreign_key: 'initiator_id',
           inverse_of: :initiator,
           dependent: :destroy

  has_many :accepted_friendships,
           class_name: 'Friend',
           foreign_key: 'acceptor_id',
           inverse_of: :acceptor,
           dependent: :destroy

  NICKNAME_LENGTH = (3..20)
  has_secure_password

  validates :nickname, presence: true, uniqueness: true, length: { minimum: NICKNAME_LENGTH.min,
                                                                   maximum: NICKNAME_LENGTH.max }
end
