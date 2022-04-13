# frozen_string_literal: true

RSpec.describe Users::Index::SetUsers do
  describe '.call' do
    subject(:result) { described_class.call }

    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    context 'when users successfully setted' do
      it 'has all users setted to collection variable' do
        expect(result.collection).to eq([user1, user2])
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end
  end
end
