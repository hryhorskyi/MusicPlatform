# frozen_string_literal: true

RSpec.describe MyAccount::Update::ValidateNicknameUniqueness do
  describe '.call' do
    subject(:result) { described_class.call(current_user: current_user, params: params, model: current_user) }

    let!(:current_user) { create(:user) }

    context 'when provided nickname is unique' do
      let(:params) { { nickname: 'nickname_test' } }

      it 'has success result' do
        expect(result).to be_success
      end
    end

    context 'when provided nickname is not unique' do
      before { create(:user, nickname: 'nickname_test') }

      let(:params) { { nickname: 'nickname_test' } }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expect(result.model.errors.messages[:nickname].first).to eq(I18n.t('my_account.update.errors.nickname_exist'))
      end
    end
  end
end
