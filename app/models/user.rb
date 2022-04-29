# frozen_string_literal: true

class User < ApplicationRecord
  NICKNAME_LENGTH = (3..20)
  FIRST_NAME_LENGTH = (3..20)
  LAST_NAME_LENGTH = (3..20)

  has_secure_password

  has_many :comments, dependent: :destroy

  has_many :playlist_songs, dependent: :destroy

  has_many :user_reactions, dependent: :destroy

  has_many :owned_playlists,
           class_name: 'Playlist',
           foreign_key: 'owner_id',
           inverse_of: :owner,
           dependent: :destroy

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

  def invitations
    received_invitations.or(sent_invitations)
  end
end
