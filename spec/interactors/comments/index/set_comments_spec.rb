# frozen_string_literal: true

RSpec.describe Comments::Index::SetComments do
  describe '.call' do
    subject(:result) { described_class.call(model: playlist) }

    let(:playlist) { create(:playlist, :public) }
    let(:comment) { create(:comment, playlist: playlist) }

    it { expect(result).to be_success }

    it 'assignees comments to collection variable' do
      expect(result.collection).to eq([comment])
    end
  end
end
