# frozen_string_literal: true

RSpec.describe Common::Service::Pagination do
  describe '.call' do
    subject(:result) { described_class.call(collection: collection, params: params) }

    before { create_list(:invitation, 10) }

    let(:collection) { Invitation.all }

    context 'when strategy is numeric' do
      context 'when all params provided' do
        let(:params) { { page: 1, per_page: 10 } }

        it 'has proper collection' do
          expected_collection = collection.first(params[:per_page])
          expect(result.collection).to match_array(expected_collection)
        end

        it 'has proper items invitations per page' do
          expect(result.collection.count).to eq(params[:per_page])
        end
      end

      context 'when params not provided' do
        before { stub_const('Pagy::DEFAULT', original_pagy_params.merge(items: 5)) }

        let(:original_pagy_params) { Pagy::DEFAULT }
        let(:params) { {} }

        it 'has proper collection with defult limit' do
          expect(result.collection).to eq(collection.first(Pagy::DEFAULT[:items]))
        end

        it 'has default count param per_page' do
          expected_collection_count = Pagy::DEFAULT[:items]
          expect(result.collection.count).to eq(expected_collection_count)
        end

        it 'has default param per_page' do
          expected_per_page_param = Pagy::DEFAULT[:items]
          expect(result.pagination_meta[:per_page]).to eq(expected_per_page_param)
        end

        it 'has default param page' do
          expected_page_param = Pagy::DEFAULT[:page]
          expect(result.pagination_meta[:self]).to eq(expected_page_param)
        end
      end

      context 'when provided only page param' do
        before { stub_const('Pagy::DEFAULT', original_pagy_params.merge(items: 5)) }

        let(:original_pagy_params) { Pagy::DEFAULT }
        let(:params) { { page: 2 } }

        it 'has proper collection on the first page' do
          expected_collection_count = Pagy::DEFAULT[:items]
          expect(result.collection.count).to eq(expected_collection_count)
        end

        it 'has proper collection' do
          expected_collection = collection[Pagy::DEFAULT[:items]..]
          expect(result.collection).to eq(expected_collection)
        end

        it 'has proper items invitations per page' do
          expected_per_page = result.pagination_meta[:per_page]
          expect(result.collection.count).to eq(expected_per_page)
        end

        it 'has default param per_page' do
          expected_per_page_param = Pagy::DEFAULT[:items]
          expect(result.pagination_meta[:per_page]).to eq(expected_per_page_param)
        end
      end

      context 'when provided only per_page param' do
        let(:params) { { per_page: 5 } }

        it 'has proper collection' do
          expected_collection = collection.first(params[:per_page])
          expect(result.collection).to eq(expected_collection)
        end

        it 'has proper items invitations per page' do
          expect(result.collection.count).to eq(params[:per_page])
        end

        it 'has default param page' do
          expected_page_param = Pagy::DEFAULT[:page]
          expect(result.pagination_meta[:self]).to eq(expected_page_param)
        end
      end

      context 'when provided page param is incorrect' do
        before { stub_const('Pagy::DEFAULT', original_pagy_params.merge(items: 5)) }

        let(:original_pagy_params) { Pagy::DEFAULT }
        let(:params) { { page: 'incorrect_page_param211' } }

        it 'return correct collection' do
          expected_collection = collection.first(Pagy::DEFAULT[:items])
          expect(result.collection).to match_array(expected_collection)
        end

        it 'has default param per page' do
          expected_per_page_param = Pagy::DEFAULT[:items]
          expect(result.pagination_meta[:per_page]).to eq(expected_per_page_param)
        end
      end

      context 'when provided per_page param is incorrect' do
        before { stub_const('Pagy::DEFAULT', original_pagy_params.merge(items: 5)) }

        let(:original_pagy_params) { Pagy::DEFAULT }
        let(:params) { { per_page: 'incorrect_per_page12_param' } }

        it 'return correct collection' do
          expected_collection = collection.first(Pagy::DEFAULT[:items])
          expect(result.collection).to eq(expected_collection)
        end

        it 'has default param page' do
          expected_page_param = Pagy::DEFAULT[:page]
          expect(result.pagination_meta[:self]).to eq(expected_page_param)
        end
      end

      context 'when provided incorrect params' do
        before { stub_const('Pagy::DEFAULT', original_pagy_params.merge(items: 5)) }

        let(:original_pagy_params) { Pagy::DEFAULT }
        let(:params) { { page: 'incorrect_page_param211', per_page: 'incorrect_per_page12_param' } }

        it 'return correct collection' do
          expected_collection = collection.first(Pagy::DEFAULT[:items])
          expect(result.collection).to eq(expected_collection)
        end
      end
    end

    context 'when strategy is cursor' do
      context 'when all params provided' do
        let(:params) { { after: collection.first.id, per_page: 5 } }

        it 'has proper collection without first invitation' do
          expected_collection_count = params[:per_page]
          expect(result.collection.count).to eq(expected_collection_count)
        end

        it 'has proper collection' do
          expected_collection = collection[1..params[:per_page]]
          expect(result.collection).to eq(expected_collection)
        end
      end

      context 'when provided only after param' do
        before { stub_const('Pagy::DEFAULT', original_pagy_params.merge(items: 5)) }

        let(:original_pagy_params) { Pagy::DEFAULT }
        let(:params) { { after: collection.first.id } }

        it 'has proper collection without first invitation' do
          expected_collection_count = Pagy::DEFAULT[:items]
          expect(result.collection.count).to eq(expected_collection_count)
        end

        it 'has proper collection' do
          expected_collection = collection[1..Pagy::DEFAULT[:items]]
          expect(result.collection).to eq(expected_collection)
        end

        it 'has proper items invitations per page' do
          expected_per_page = result.pagination_meta[:per_page]
          expect(result.collection.count).to eq(expected_per_page)
        end

        context 'when provided uuid page param is incorrect' do
          let(:params) { { after: SecureRandom.uuid } }

          it 'return empty collection' do
            expect(result.collection).to be_empty
          end
        end
      end
    end
  end
end
