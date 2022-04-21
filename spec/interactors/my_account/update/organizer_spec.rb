# frozen_string_literal: true

RSpec.describe MyAccount::Update::Organizer do
  describe '.call' do
    subject(:result) { described_class.call(current_user: current_user, params: params) }

    let!(:current_user) { create(:user) }
    let(:expected_interactors) do
      [
        MyAccount::Update::Initialization,
        MyAccount::Update::SetBaseModel,
        Common::Model::ValidateParams,
        MyAccount::Update::ValidateNicknameUniqueness,
        Common::Model::AssignAttributes,
        Common::Model::Persist
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when provided params are correct' do
      let(:params) do
        {
          nickname: 'nickname_test',
          first_name: 'first_name_test',
          last_name: 'last_name_test'
        }
      end

      it 'has success result' do
        expect(result).to be_success
      end

      it 'has changed nickname' do
        previous_nickname = current_user.nickname
        expect { result }.to change { current_user.nickname }.from(previous_nickname).to(params[:nickname])
      end

      it 'has changed first_name' do
        previous_first_name = current_user.first_name
        expect { result }.to change { current_user.first_name }.from(previous_first_name).to(params[:first_name])
      end

      it 'has changed last_name' do
        previous_last_name = current_user.last_name
        expect { result }.to change { current_user.last_name }.from(previous_last_name).to(params[:last_name])
      end
    end

    context 'when provided first_name is incorrect' do
      let(:params) do
        {
          nickname: 'nickname_test',
          first_name: '.',
          last_name: 'last_name_test'
        }
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('errors.messages.too_short.other', count: 3)
        expect(result.model.errors.messages[:first_name].first).to eq(expected_error)
      end
    end

    context 'when provided last_name is incorrect' do
      let(:params) do
        {
          nickname: 'nickname_test',
          first_name: 'first_name_test',
          last_name: '.'
        }
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('errors.messages.too_short.other', count: 3)
        expect(result.model.errors.messages[:last_name].first).to eq(expected_error)
      end
    end

    context 'when provided nickname is incorrect' do
      let(:params) do
        {
          nickname: '.',
          first_name: 'first_name_test',
          last_name: 'last_name_test'
        }
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('errors.messages.too_short.other', count: 3)
        expect(result.model.errors.messages[:nickname].first).to eq(expected_error)
      end
    end

    context 'when provided nickname is not unique' do
      before { create(:user, nickname: 'nickname_test') }

      let(:params) do
        {
          nickname: 'nickname_test',
          first_name: 'first_name_test',
          last_name: 'last_name_test'
        }
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expect(result.model.errors.messages[:nickname].first).to eq(I18n.t('my_account.update.errors.nickname_exist'))
      end
    end
  end
end
