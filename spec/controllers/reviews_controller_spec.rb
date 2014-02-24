require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    before { set_current_user }

    let(:video) { Fabricate(:video) }

    it_behaves_like 'require signin' do
      let(:action) { post :create, video_id: 1 }
    end

    context 'with authenticated users' do
      context 'input is valid' do
        before do
          session[:user_id] = current_user.id
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end

        it 'redirects the user to current video path' do
          expect(response).to redirect_to video
        end

        it 'creates a review' do
          expect(Review.count).to eq(1)
        end

        it 'creates a review associated with the video' do
          expect(Review.first.video).to eq(video)
        end

        it 'creates a review associated with the signed in user' do
          expect(Review.first.user).to eq(current_user)
        end

        it 'assigns flash message' do
          expect(flash[:info]).to_not be_blank
        end
      end

      context 'input is invalid' do
        it 'does not create a review' do
          post :create, video_id: video.id, review: { rating: 5 }
          expect(Review.count).to eq(0)
        end

        it 'sets @video' do
          post :create, video_id: video.id, review: { rating: 5 }
          expect(assigns(:video)).to eq(video)
        end

        it 'sets @reviews' do
          review = Fabricate(:review, video: video)
          post :create, video_id: video.id, review: { rating: 5 }
          expect(assigns(:reviews)).to match_array([review])
        end

        it 'renders the show template' do
          post :create, video_id: video.id, review: { rating: 5 }
          expect(response).to render_template 'videos/show'
        end
      end
    end
  end
end