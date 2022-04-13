# frozen_string_literal: true

RSpec.describe Users::Index::FilterByUser do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: user1, params: { exclude_friends: {} }, collection: User.all)
    end

    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }

    it 'has users without current_user setted to collection variable' do
      expect(result.collection).to eq([user2, user3])
    end

    it { expect(result).to be_success }
  end
end
