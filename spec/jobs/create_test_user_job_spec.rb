# frozen_string_literal: true

RSpec.describe CreateTestUserJob, type: :job do
  describe 'perform' do
    it 'creates a user' do
      Sidekiq::Testing.inline!

      expect { described_class.perform_async }.to change { User.count }.by(1)
    end

    it 'add job to queue' do
      Sidekiq::Testing.fake!

      expect { described_class.perform_async }.to change { described_class.jobs.size }.by(1)
    end
  end
end
