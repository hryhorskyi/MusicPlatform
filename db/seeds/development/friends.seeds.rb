# frozen_string_literal: true

after 'development:users' do
  Friend.create(initiator: User.find_by(email: 'initiator@epam.com'),
                acceptor: User.find_by(email: 'acceptor@epam.com'))
end
