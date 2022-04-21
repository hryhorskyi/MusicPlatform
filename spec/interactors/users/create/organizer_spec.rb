# frozen_string_literal: true

RSpec.describe Users::Create::Organizer do
  describe '.call' do
    subject(:result) { described_class.call(current_user: current_user, params: params) }

    let!(:current_user) { create(:user) }
    let(:expected_interactors) do
      [
        Users::Create::Initialization,
        Users::Create::SetBaseModel,
        Common::Model::ValidateParams,
        Common::Model::Persist
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when provided params are correct' do
      let(:params) do
        {
          email: 'email@test.com',
          password: 'P@ssw0rd',
          password_confirmation: 'P@ssw0rd',
          nickname: 'test_nickname'
        }
      end

      it 'has success result' do
        expect(result).to be_success
      end
    end

    context 'when provided email incorrect' do
      let(:params) do
        {
          email: 'email',
          password: 'P@ssw0rd',
          password_confirmation: 'P@ssw0rd',
          nickname: 'test_nickname'
        }
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expect(result.model.errors.messages[:email].first).to eq('is invalid')
      end
    end

    context 'when provided password is incorrect' do
      let(:params) do
        {
          email: 'email@test.com',
          password: 'password',
          password_confirmation: 'P@ssw0rd',
          nickname: 'test_nickname'
        }
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expect(result.model.errors.messages[:password].first).to eq('is invalid')
      end
    end

    context 'when provided password_confirmation does not match with password' do
      let(:params) do
        {
          email: 'email@test.com',
          password: 'P@ssw0rd',
          password_confirmation: 'password',
          nickname: 'test_nickname'
        }
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expect(result.model.errors.messages[:password_confirmation].first).to eq('doesn\'t match Password')
      end
    end

    context 'when provided nickname is incorrect' do
      let(:params) do
        {
          email: 'email@test.com',
          password: 'P@ssw0rd',
          password_confirmation: 'P@ssw0rd',
          nickname: '.'
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
          email: 'email@test.com',
          password: 'P@ssw0rd',
          password_confirmation: 'P@ssw0rd',
          nickname: 'nickname_test'
        }
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expect(result.model.errors.messages[:nickname].first).to eq(I18n.t('users.create.errors.nickname_exist'))
      end
    end

    context 'when provided email is not unique' do
      before { create(:user, email: 'email@test.com') }

      let(:params) do
        {
          email: 'email@test.com',
          password: 'P@ssw0rd',
          password_confirmation: 'P@ssw0rd',
          nickname: 'nickname_test'
        }
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expect(result.model.errors.messages[:email].first).to eq(I18n.t('users.create.errors.email_exist'))
      end
    end

    context 'when provided email and nickname are not unique' do
      before do
        create(:user, email: 'email@test.com', nickname: 'nickname_test')
      end

      let(:params) do
        {
          email: 'email@test.com',
          password: 'P@ssw0rd',
          password_confirmation: 'P@ssw0rd',
          nickname: 'nickname_test'
        }
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_output = [
          [I18n.t('users.create.errors.nickname_exist')],
          [I18n.t('users.create.errors.email_exist')]
        ]
        expect(result.model.errors.messages.values).to eq(expected_output)
      end
    end
  end
end
