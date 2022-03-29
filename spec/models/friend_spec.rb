# frozen_string_literal: true

RSpec.describe Friend, type: :model do
  describe 'fields' do
    %i[initiator_id acceptor_id].each do |field|
      it { is_expected.to have_db_column(field).of_type(:integer) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:initiator).class_name('User') }
    it { is_expected.to belong_to(:acceptor).class_name('User') }
  end

  describe 'validations' do
    describe 'initiator_id' do
      it { is_expected.to validates_comparison_other_than(:acceptor_id) }
    end

    describe 'acceptor_id' do
      it { is_expected.to validates_comparison_other_than(:initiator_id) }
    end
  end
end
