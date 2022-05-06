# frozen_string_literal: true

RSpec.describe Playlists::Create::BuildAttributes do
  describe '.call' do
    subject(:result) { described_class.call(current_user: current_user, params: params) }

    context 'when a model_params assigned correctly' do
      let(:current_user) { create(:user) }
      let(:params) { { name: 'playlist', description: 'description', playlist_type: 'public' } }

      it 'has success result' do
        expect(result).to be_success
      end

      it 'has assigned model_params' do
        expect(result.model_params).to eq(params.merge({ owner: current_user }))
      end
    end
  end
end
