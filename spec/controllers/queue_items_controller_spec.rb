require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    context 'with unauthenticated users' do
      it 'redirects user to signin path' do
        get :index
        expect(response).to redirect_to signin_path
      end
    end

    context 'with authenticated users' do
      let(:user) { Fabricate(:user) }

      before do
        session[:user_id] = user.id
        @items = 4.times.map{ Fabricate(:queue_item, user: user) }
        get :index
      end

      it 'assigns queue items for user' do
        expect(assigns(:queue_items)).to match_array(@items)
      end

      it 'renders template' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'POST create' do
    context 'with unauthenticated users' do
      it 'redirects user to signin path' do
        post :create, video_id: 1
        expect(response).to redirect_to signin_path
      end
    end

    context 'with authenticated users' do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      context 'the video is not in the current user queue' do
        before do
          session[:user_id] = user.id
        end

        it 'creates a new queue item' do
          post :create, video_id: video.id
          expect(QueueItem.count).to eq(1)
        end

        it 'creates the queue item that is associated with the video' do
          post :create, video_id: video.id
          expect(QueueItem.first.video).to eq(video)
        end

        it 'creates the queue item that is associated with the user' do
          post :create, video_id: video.id
          expect(QueueItem.first.user).to eq(user)
        end

        it 'puts the video as the last one in the queue' do
          video_1 = Fabricate(:video)
          video_2 = Fabricate(:video)
          Fabricate(:queue_item, video: video_1, user: user)
          post :create, video_id: video_2.id
          expect(QueueItem.where(video_id: video_2.id, user_id: user.id).first.list_order).to eq(2)
        end

        it 'redirects user to my queue page' do
          post :create, video_id: video.id
          expect(response).to redirect_to my_queue_path
        end
      end

      context 'the video is already in the current user queue' do
        before do
          session[:user_id] = user.id
          video = Fabricate(:video)
          queue_item = Fabricate(:queue_item, video: video, user: user)
          post :create, video_id: video.id
        end

        it 'does not save a new queue item' do
          expect(QueueItem.count).to eq(1)
        end

        it 'sets flash now notice of already in queue' do
          expect(flash.now[:danger]).to_not be_blank
        end

        it 'redirects user back to current video page' do
          expect(response).to render_template 'videos/show'
        end
      end
    end
  end
end