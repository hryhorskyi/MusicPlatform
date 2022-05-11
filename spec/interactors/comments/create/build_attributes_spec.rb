# frozen_string_literal: true

RSpec.describe Comments::Create::BuildAttributes do
  describe '.call' do
    subject(:result) { described_class.call(current_user: current_user, params: params, playlist: playlist) }

    context 'when a model_params assigned correctly' do
      let(:current_user) { create(:user) }
      let(:params) { { playlist: playlist, text: 'text' } }
      let(:playlist) { create(:playlist) }

      it 'has success result' do
        expect(result).to be_success
      end

      it 'has assigned model_params' do
        expect(result.model_params).to eq(params.merge({ user: current_user, playlist: playlist, text: params[:text] }))
      end

      context 'when the user pass to params text with trailing whitespaces' do
        let(:params) { { playlist: playlist, text: '    some_text is here    ' } }

        it 'has strip works correct' do
          expect(result.model_params[:text]).to eq('some_text is here')
        end
      end
    end
  end
end
