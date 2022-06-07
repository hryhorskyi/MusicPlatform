# frozen_string_literal: true

RSpec.describe Comments::Index::Organizer do
  describe '.call' do
    subject(:result) { described_class.call(current_user: user, params: params) }

    let(:user) { create(:user) }
    let(:params) { { playlist_id: playlist.id } }
    let(:expected_interactors) do
      [
        Comments::Index::Initialize,
        Comments::Index::FindPlaylist,
        Common::Policy::Check,
        Comments::Index::SetComments,
        Common::Service::Pagination
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when success' do
      let(:comment) { create(:comment, playlist: playlist) }

      context 'when playlist is public' do
        let(:playlist) { create(:playlist, :public) }

        context 'when user is given' do
          it { expect(result).to be_success }
        end

        context 'when user is not given' do
          let(:user) { nil }

          it { expect(result).to be_success }
        end

        it { expect(result.collection).to eq([comment]) }
      end

      context 'when playlist is shared' do
        let(:owner) { create(:user) }
        let(:playlist) { create(:playlist, :shared, owner: owner) }

        context 'when user is owner of playlist' do
          let(:owner) { user }

          it { expect(result).to be_success }
          it { expect(result.collection).to eq([comment]) }
        end

        context 'when user is owners friend' do
          before do
            create(:friend, acceptor: user, initiator: owner)
          end

          it { expect(result).to be_success }
          it { expect(result.collection).to eq([comment]) }
        end
      end

      context 'with pagination' do
        before { create_list(:comment, 10, playlist: playlist) }

        let(:playlist) { create(:playlist, :public) }
        let(:collection) { playlist.comments.order(Pagy::DEFAULT[:default_order]) }

        context 'when provided params per_page and page' do
          let(:params) { { playlist_id: playlist.id, page: page, per_page: per_page } }
          let(:page) { 1 }
          let(:per_page) { 5 }

          it 'has proper collection' do
            expect(result.collection).to eq(collection.first(per_page))
          end

          it 'has proper items invitations per page' do
            expect(result.collection.count).to eq(per_page)
          end

          it 'returns change pagy items' do
            expect(Pagy::DEFAULT[:items]).to eq(30)
          end
        end

        context 'when provided params after and per_page' do
          let(:params) { { playlist_id: playlist.id, after: after, per_page: per_page } }
          let(:after) { collection.first.id }
          let(:per_page) { 5 }

          it 'has proper collection without first invitation' do
            expect(result.collection.count).to eq(per_page)
          end

          it 'has proper collection' do
            expect(result.collection).to eq(collection[1..per_page])
          end

          it 'returns change pagy items' do
            expect(Pagy::DEFAULT[:items]).to eq(30)
          end
        end
      end
    end

    context 'when failure' do
      context 'when playlist is private' do
        let(:playlist) { create(:playlist, :private, owner: owner) }

        context 'when user is owner of playlist' do
          let(:owner) { user }

          it { expect(result).not_to be_success }
        end

        context 'when user is guest' do
          let(:owner) { create(:user) }
          let(:user) { nil }

          it { expect(result).not_to be_success }
        end
      end

      context 'when playlist is shared' do
        let(:playlist) { create(:playlist, :shared, owner: owner) }

        context 'when user is guest' do
          let(:user) { nil }
          let(:owner) { create(:user) }

          it { expect(result).not_to be_success }
        end

        context 'when user is not a friend of playlist owner' do
          let(:owner) { create(:user) }

          it { expect(result).not_to be_success }
        end
      end
    end
  end
end
