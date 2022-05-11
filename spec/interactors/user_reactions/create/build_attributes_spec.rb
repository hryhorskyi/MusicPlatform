# frozen_string_literal: true

RSpec.describe UserReactions::Create::BuildAttributes do
  describe '.call' do
    subject(:result) { described_class.call(current_user: current_user, playlist: playlist, params: params) }

    context 'when current_user and params assigned correctly' do
      let(:current_user) { create(:user) }
      let(:playlist) { create(:playlist) }
      let(:params) { { reaction: 'like' } }

      it 'has success result' do
        expect(result).to be_success
      end

      it 'has assigned model_params' do
        expect(result.model_params).to eq(params.merge({ user: current_user, playlist: playlist,
                                                         reaction: params[:reaction] }))
      end
    end
  end
end
