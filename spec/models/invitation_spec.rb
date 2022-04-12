# frozen_string_literal: true

RSpec.describe Invitation, type: :model do
  describe 'fields' do
    %i[requestor_id receiver_id status].each do |field|
      it { is_expected.to have_db_column(field).of_type(:integer) }
    end

    it { is_expected.to have_db_column(:declined_at).of_type(:datetime) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:requestor).class_name('User').inverse_of(:invitations) }
    it { is_expected.to belong_to(:receiver).class_name('User').inverse_of(:invitations) }
  end

  describe 'validations' do
    describe 'requestor_id' do
      it { is_expected.to validates_comparison_other_than(:acceptor_id) }
    end

    describe 'receiver_id' do
      it { is_expected.to validates_comparison_other_than(:initiator_id) }
    end
  end

  it { is_expected.to validate_presence_of(:status) }
end
