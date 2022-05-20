# frozen_string_literal: true

RSpec.describe Common::Model::ImageDerivatives do
  describe '.call' do
    subject(:result) { described_class.call(model: user) }

    context 'when avatar passed' do
      let(:user) { create(:user, :with_avatar) }

      it 'has success' do
        expect(result).to be_success
      end

      it 'has correct keys' do
        expect(result.model.avatar_derivatives.keys).to eq(%i[small medium large])
      end
    end

    context 'when avatar not passed' do
      let(:user) { create(:user) }

      it 'has success' do
        expect(result).to be_success
      end

      it 'has correct keys' do
        expect(result.model.avatar_derivatives).to be_empty
      end
    end
  end
end
