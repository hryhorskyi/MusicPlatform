# frozen_string_literal: true

RSpec.describe Comments::Create::Organizer do
  describe '.call' do
    subject(:result) { described_class.call(current_user: user, params: params) }

    let(:user) { create(:user) }
    let(:playlist) { create(:playlist, :public) }
    let(:params) { { playlist_id: playlist.id, text: text } }
    let(:expected_interactors) do
      [
        Comments::Create::Initialize,
        Common::Model::Initialize,
        Comments::Create::FindPlaylist,
        Comments::Create::BuildAttributes,
        Common::Model::AssignAttributes,
        Common::Model::Validate,
        Common::Policy::Check,
        Common::Model::Persist
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when comment successfully created' do
      let(:text) { 'This is comment' }

      it 'has successful result' do
        expect(result).to be_success
      end

      it 'persisted comment to playlist' do
        expect { result }.to change { playlist.comments.count }.from(0).to(1)
      end
    end

    context 'when comment text is incorrect' do
      context 'when comment text is too short' do
        let(:text) { 'short' }

        it 'has failure result' do
          expect(result).to be_failure
        end

        it 'persisted comment to playlist' do
          expect { result }.not_to(change { playlist.comments.count })
        end

        it 'has correct error message' do
          expected_message = I18n.t('errors.messages.too_short.other', count: Comment::TEXT_LENGTH.min)

          expect(result.model.errors.messages[:text].first).to eq(expected_message)
        end
      end

      context 'when comment text is too long' do
        let(:text) { FFaker::Lorem.characters(Comment::TEXT_LENGTH.max + 1) }

        it 'has failure result' do
          expect(result).to be_failure
        end

        it 'persisted comment to playlist' do
          expect { result }.not_to(change { playlist.comments.count })
        end

        it 'has correct error message' do
          expected_message = I18n.t('errors.messages.too_long.other', count: Comment::TEXT_LENGTH.max)

          expect(result.model.errors.messages[:text].first).to eq(expected_message)
        end
      end
    end

    context 'when a user has more than 3 comments and the last comments was written in less than 1 minute' do
      before do
        create_list(:comment, CommentsPolicy::AVAILABLE_COMMENTS_COUNT_PER_MINUTE, playlist_id: playlist.id, user: user)
      end

      let(:text) { 'This is comment' }

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
