# frozen_string_literal: true

RSpec.describe ShrineImageBuilder, type: :service do
  describe '.call' do
    subject(:result) { described_class.call(image: avatar, filename: 'test_image.png') }

    let(:avatar) { Base64.encode64(File.read(Rails.root.join('spec/fixtures/files/image.png'))) }
    let(:correct_image) { Rack::Test::UploadedFile.new('spec/fixtures/files/image.png', 'image/png') }
    let(:params) { { image: avatar, filename: 'test_image.png' } }

    it 'has correct kind' do
      expect(result).to be_kind_of(Shrine::DataFile)
    end

    it 'has correct size' do
      expect(result.size).to eq(correct_image.size)
    end
  end
end
