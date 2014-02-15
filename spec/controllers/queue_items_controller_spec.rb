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

      before do
        session[:user_id] = user.id
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

      it 'creates a new queue item if the video is not in user queue' do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it 'does not create a new queue item if the video is in user queue' do
        queue_item = Fabricate(:queue_item, video: video, user: user)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it 'redirects user to my queue page' do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with unauthenticated users' do
      it 'redirects user to signin path' do
        post :create, video_id: 1
        expect(response).to redirect_to signin_path
      end
    end

    context 'with authenticated users' do
      let(:user) { Fabricate(:user) }
      let(:queue_item) { Fabricate(:queue_item, user: user) }

      before do
        session[:user_id] = user.id
      end

      it 'deletes the queue item' do
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it 'does not delete the queue item if it does not belong to current user' do
        other_user = Fabricate(:user, email: 'example@example.com')
        other_queue_item = Fabricate(:queue_item, user: other_user)
        delete :destroy, id: other_queue_item.id
        expect(QueueItem.exists?(other_queue_item.id)).to eq(true)
      end

      it 'reorders user queue list order sequentially' do
        2.times { |i| Fabricate(:queue_item, user: user) }
        delete_id = queue_item.id
        Fabricate(:queue_item, user: user)
        Fabricate(:queue_item, user: user)
        delete :destroy, id: delete_id
        expect(QueueItem.last.list_order).to eq(4)
      end

      it 'redirects to my queue page' do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end
    end
  end
end