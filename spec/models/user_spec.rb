# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'fields' do
    %i[nickname email password_digest].each do |field|
      it { is_expected.to have_db_column(field).of_type(:string).with_options(null: false) }
    end

    %i[first_name last_name avatar_data].each do |field|
      it { is_expected.to have_db_column(field).of_type(:string) }
    end

    it { is_expected.to have_db_index(:nickname).unique(true) }
    it { is_expected.to have_db_index(:email).unique(true) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:playlist_songs).dependent(:destroy) }
    it { expect(build(:user)).to have_many(:user_reactions).dependent(:destroy) }

    it {
      expect(build(:user)).to have_many(:owned_playlists).class_name('Playlist').with_foreign_key('owner_id')
                                                         .inverse_of(:owner).dependent(:destroy)
    }

    it {
      expect(build(:user)).to have_many(:initiated_friendships).class_name('Friend').with_foreign_key('initiator_id')
                                                               .inverse_of(:initiator).dependent(:destroy)
    }

    it {
      expect(build(:user)).to have_many(:accepted_friendships).class_name('Friend').with_foreign_key('acceptor_id')
                                                              .inverse_of(:acceptor).dependent(:destroy)
    }

    it {
      expect(build(:user)).to have_many(:received_invitations).class_name('Invitation').with_foreign_key('receiver_id')
                                                              .inverse_of(:receiver).dependent(:destroy)
    }

    it {
      expect(build(:user)).to have_many(:sent_invitations).class_name('Invitation').with_foreign_key('requestor_id')
                                                          .inverse_of(:requestor).dependent(:destroy)
    }
  end

  describe '#invintations' do
    let(:user) { create(:user) }
    let(:invitation_list) { create_list(:invitation, 2, requestor_id: user.id) }

    it 'returns users invitation' do
      expect(user.invitations).to eq(invitation_list)
    end
  end

  describe '#friends' do
    let(:user) { create(:user) }
    let(:friends_list_for_initiator) { create_list(:friend, 3, initiator_id: user.id) }
    let(:friends_list_for_acceptor) { create_list(:friend, 3, acceptor_id: user.id) }

    it 'returns user friends' do
      expect(user.friends).to match_array(friends_list_for_initiator + friends_list_for_acceptor)
    end
  end
end
