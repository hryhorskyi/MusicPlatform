# frozen_string_literal: true

# Predefined users
User.create(
  email: 'initiator@epam.com',
  nickname: 'Initiat0r',
  password: 'P@ssword1'
)

User.create(
  email: 'acceptor@epam.com',
  nickname: 'Accept0r',
  password: 'P@ssword2'
)

Friend.create(initiator_id: 1, acceptor_id: 2)

# Random Users
3.times do
  email    = FFaker::Internet.email
  nickname = FFaker::Lorem.characters(rand(User::NICKNAME_LENGTH))
  password = FFaker::Internet.password.delete('_') + %w[@ $ ! % * ? &].sample + rand(10).to_s

  User.create(
    email: email,
    nickname: nickname,
    password: password
  )
end
