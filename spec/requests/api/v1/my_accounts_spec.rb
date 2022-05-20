# frozen_string_literal: true

RSpec.describe 'MyAccounts', type: :request do
  path '/api/v1/my_account' do
    get(I18n.t('swagger.my_account.action.show')) do
      tags I18n.t('swagger.my_account.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true

      let!(:user) { create(:user) }

      response '200', 'ok' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }

        run_test! do |response|
          expect(response).to match_json_schema('v1/my_account/show')
        end
      end

      response '401', 'unauthorized' do
        let(:authorization) { nil }

        run_test!
      end
    end

    patch(I18n.t('swagger.my_account.action.update')) do
      tags I18n.t('swagger.my_account.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true
      parameter name: :my_account, in: :body, schema: {
        type: :object,
        properties: {
          nickname: { type: :string },
          first_name: { type: :string },
          last_name: { type: :string },
          avatar: {
            content: { type: :string },
            filename: { type: :string }
          }
        },
        example: {
          nickname: FFaker::Internet.user_name,
          first_name: FFaker::Name.first_name,
          last_name: FFaker::Name.last_name,
          avatar: { content: 'your_base64_image', filename: 'name_your_file' }
        },
        required: %w[nickname first_name last_name avatar]
      }

      let!(:current_user) { create(:user, :with_avatar) }

      response '200', 'when params is correct' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:my_account) do
          { nickname: current_user.nickname,
            first_name: 'test_name1',
            last_name: 'lastname',
            avatar: { content: avatar, original_filename: 'test_image.png' } }
        end

        let(:avatar) { Base64.encode64(File.read(Rails.root.join('spec/fixtures/files/image.png'))) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/my_account/show')
        end
      end

      response '401', 'unauthorized' do
        let(:authorization) { nil }
        let(:my_account) { { nickname: current_user.nickname, first_name: 'test_name1', last_name: 'lastname' } }

        run_test!
      end

      response '422', 'when passed all empty params' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:my_account) { { nickname: '.', first_name: '.', last_name: '.' } }

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when passed incorrect nickname ' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:my_account) do
          { nickname: '',
            first_name: 'first_name',
            last_name: 'lastname',
            avatar: { content: '', original_filename: '' } }
        end

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when passed incorrect first_name ' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:my_account) do
          { nickname: current_user.nickname,
            first_name: '',
            last_name: 'lastname',
            avatar: { content: '', original_filename: '' } }
        end

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when passed incorrect last_name ' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:my_account) do
          { nickname: current_user.nickname,
            first_name: 'test_name1',
            last_name: '',
            avatar: { content: '', original_filename: '' } }
        end

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when passed incorrect avatar ' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:my_account) do
          { nickname: current_user.nickname,
            first_name: 'test_name1',
            last_name: 'last_name',
            avatar: { content: 'dgsgdgdgdgd', original_filename: 'file_name.jpg' } }
        end

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end
    end
  end
end
