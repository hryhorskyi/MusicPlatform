# frozen_string_literal: true

RSpec.describe MyAccount::Update::BuildAvatarAttributes do
  describe '.call' do
    subject(:result) { described_class.call(params: { avatar: params }, params_for_validation: {}) }

    let(:content) { Base64.encode64(File.read(Rails.root.join('spec/fixtures/files/image.png'))) }
    let(:params) { { content: content, filename: 'test_image.png' } }

    context 'when a model_params assigned correctly' do
      it 'has success' do
        expect(result).to be_success
      end

      it 'params avatar has correct kind' do
        expect(result.params[:avatar]).to be_kind_of(Shrine::DataFile)
      end

      it 'params_for_validation has correct kind' do
        expect(result.params_for_validation[:avatar]).to be_kind_of(Shrine::DataFile)
      end
    end

    context 'when avatar is nil' do
      let(:params) { nil }

      it 'has success' do
        expect(result).to be_success
      end

      it 'params avatar is nil' do
        expect(result.params[:avatar]).to be_nil
      end

      it 'avatar params_for_validation is nil' do
        expect(result.params_for_validation[:avatar]).to be_nil
      end
    end
  end
end
