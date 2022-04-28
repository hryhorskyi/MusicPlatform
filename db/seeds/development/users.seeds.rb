# frozen_string_literal: true

User.create(
  email: 'initiator@epam.com',
  nickname: 'Initiat0r',
  password: 'P@ssword',
  password_confirmation: 'P@ssword'
)

User.create(
  email: 'acceptor@epam.com',
  nickname: 'Accept0r',
  password: 'P@ssword',
  password_confirmation: 'P@ssword'
)
