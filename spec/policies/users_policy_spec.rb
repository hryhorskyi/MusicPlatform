# frozen_string_literal: true

RSpec.describe UsersPolicy, type: :policy do
  subject(:result) { described_class.new(current_user, user_for_remove) }

  let(:current_user) { create(:user) }
  let(:user_for_remove) { current_user }

  context 'when user is owner' do
    it { is_expected.to permit(:destroy) }
  end

  context 'when user is playlist owner' do
    let(:user_for_remove) { create(:user) }

    it { is_expected.not_to permit(:destroy) }
  end
end
