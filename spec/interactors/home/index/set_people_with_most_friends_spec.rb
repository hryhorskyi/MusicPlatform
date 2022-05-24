# frozen_string_literal: true

RSpec.describe Home::Index::SetPeopleWithMostFriends do
  describe '.call' do
    subject(:result) { described_class.call(model: model) }

    let(:model) { Struct.new(:people_with_most_friends).new }

    context 'with precreated friends' do
      before do
        create_list(:friend, 10)
      end

      it 'set right quantity of friends' do
        expect(result.model.people_with_most_friends.count).to eq(described_class::PEOPLE_QUANTITY)
        expect(result).to be_success
      end
    end
  end
end
