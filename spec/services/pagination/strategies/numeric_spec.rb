# frozen_string_literal: true

RSpec.describe Pagination::Strategies::Numeric do
  subject(:paginator) { described_class.new(params) }

  before { create_list(:invitation, 10) }

  describe '#paginate' do
    let(:paginate_collection) { paginator.collection }
    let(:pagination) { paginator.paginate(collection) }
    let(:params) { { page: page, per_page: per_page } }

    context 'when provided collection has invitations' do
      let(:collection) { Invitation.all }
      let(:page) { 1 }
      let(:per_page) { 10 }

      it 'returns changed attribute paginated' do
        expect { pagination }.to change { paginator.paginated }.from(false).to(true)
      end

      it 'returns correct paginate of collection' do
        pagination
        expect(paginate_collection).to eq(collection.first(params[:per_page]))
      end

      it 'returns correct counter of invitations' do
        pagination
        expect(paginate_collection.count).to eq(collection.first(params[:per_page]).count)
      end
    end

    context 'when provided collection has not invitations' do
      let(:collection) { Invitation.none }
      let(:page) { 1 }
      let(:per_page) { 10 }

      it 'returns changed attribute paginated' do
        expect { pagination }.to change { paginator.paginated }.from(false).to(true)
      end

      it 'returns correct counter of invitations' do
        pagination
        expect(paginate_collection.count).to be_zero
      end
    end

    context 'when provided per_page param' do
      let(:collection) { Invitation.all }
      let(:page) { 1 }
      let(:per_page) { 5 }

      it 'returns changed attribute paginated with custom per_page param' do
        expect { pagination }.to change { paginator.paginated }.from(false).to(true)
      end

      it 'returns correct paginate of collection with custom per_page param' do
        pagination
        expect(paginate_collection).to eq(collection.first(params[:per_page]))
      end

      it 'returns correct counter of invitations with custom per_page param' do
        pagination
        expect(paginate_collection.count).to eq(collection.first(params[:per_page]).count)
      end
    end

    context 'when not provided per_page param' do
      let(:collection) { Invitation.all }
      let(:page) { 1 }
      let(:params) { { page: page } }

      it 'returns changed attribute paginated with default per_page param' do
        expect { pagination }.to change { paginator.paginated }.from(false).to(true)
      end

      it 'returns correct paginate of collection with default per_page param' do
        pagination
        expect(paginate_collection).to eq(collection.first(Pagy::DEFAULT[:items]))
      end

      it 'returns correct counter of invitations with default per_page param' do
        pagination
        expect(paginate_collection.count).to eq(collection.first(Pagy::DEFAULT[:items]).count)
      end
    end

    context 'when provided empty line per_page param' do
      let(:collection) { Invitation.all }
      let(:page) { 1 }
      let(:params) { { page: page, per_page: '' } }

      it 'returns changed attribute paginated with default per_page param' do
        expect { pagination }.to change { paginator.paginated }.from(false).to(true)
      end

      it 'returns correct paginate of collection with default per_page param' do
        pagination
        expect(paginate_collection).to eq(collection.first(Pagy::DEFAULT[:items]))
      end

      it 'returns correct counter of invitations with default per_page param' do
        pagination
        expect(paginate_collection.count).to eq(collection.first(Pagy::DEFAULT[:items]).count)
      end
    end

    context 'when provided incorrect line per_page param' do
      let(:collection) { Invitation.all }
      let(:page) { 1 }
      let(:params) { { page: page, per_page: 'asd' } }

      it 'returns changed attribute paginated with default per_page param' do
        expect { pagination }.to change { paginator.paginated }.from(false).to(true)
      end

      it 'returns correct paginate of collection with default per_page param' do
        pagination
        expect(paginate_collection).to eq(collection.first(Pagy::DEFAULT[:items]))
      end

      it 'returns correct counter of invitations with default per_page param' do
        pagination
        expect(paginate_collection.count).to eq(collection.first(Pagy::DEFAULT[:items]).count)
      end
    end

    context 'when provided not exist param page' do
      let(:collection) { Invitation.all }
      let(:page) { 102_020 }
      let(:per_page) { 2 }

      it 'returns changed attribute paginated' do
        expect { pagination }.to change { paginator.paginated }.from(false).to(true)
      end

      it 'returns correct counter of invitations' do
        pagination
        expect(paginate_collection.count).to be_zero
      end
    end

    context 'when provided param page with string value' do
      let(:collection) { Invitation.all }
      let(:page) { '102_020' }
      let(:per_page) { 2 }

      it 'returns changed attribute paginated' do
        expect { pagination }.to change { paginator.paginated }.from(false).to(true)
      end

      it 'returns correct counter of invitations' do
        pagination
        expect(paginate_collection.count).to be_zero
      end
    end
  end

  describe '#paginated_collection' do
    let(:paginate_collection) { paginator.paginated_collection }
    let(:params) { { page: page } }

    context 'when calling method before executed method paginate' do
      let(:page) { 1 }

      it 'raise error StandardError type' do
        expected_error_message = I18n.t('services.pagination.errors.not_paginated_yet_error')
        expect { paginate_collection }.to raise_error(Pagination::Errors::NotPaginatedYetError, expected_error_message)
      end
    end

    context 'when calling method after executed method paginate' do
      before { paginator.paginate(collection) }

      let(:page) { 1 }
      let(:collection) { Invitation.all }

      it 'returns correct paginated_collection' do
        expect(paginate_collection).to eq(collection.first(Pagy::DEFAULT[:items]))
      end
    end
  end

  describe '#pagintion_meta' do
    let(:pagination_meta) { paginator.pagination_meta }
    let(:params) { { page: page, per_page: per_page } }
    let(:page) { 2 }
    let(:per_page) { 2 }

    context 'when calling method before executed method paginate' do
      it 'raise error StandardError type' do
        expected_error_message = I18n.t('services.pagination.errors.not_paginated_yet_error')
        expect { pagination_meta }.to raise_error(Pagination::Errors::NotPaginatedYetError, expected_error_message)
      end
    end

    context 'when calling method after executed method paginate' do
      before { paginator.paginate(collection) }

      let(:collection) { Invitation.all }
      let(:prev_page) { (page - 1).negative? ? nil : page - 1 }
      let(:last_page) { (collection.count / per_page.to_f).ceil }
      let(:expected_pagination_meta) do
        {
          per_page: per_page,
          max_per_page: Pagy::DEFAULT[:max_items],
          count: collection.count,
          self: page,
          next: page + 1,
          last: last_page,
          prev: prev_page
        }
      end

      it 'returns correct pagination_meta' do
        expect(pagination_meta).to eq(expected_pagination_meta)
      end
    end
  end
end
