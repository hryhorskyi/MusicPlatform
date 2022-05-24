# frozen_string_literal: true

RSpec.describe Home::Index::SetTopContributors do
  describe '.call' do
    subject(:result) { described_class.call(model: model) }

    let(:model) { Struct.new(:top_contributors).new }

    context 'with precreated users' do
      before do
        create_list(:user, 10)
      end

      it 'set right quantity of users' do
        expect(result.model.top_contributors.count).to eq(described_class::CONTRIBUTORS_QUANTITY)
        expect(result).to be_success
      end
    end
  end
end
