require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    before { set_current_user }

    it_behaves_like 'require signin' do
      let(:action) { get :index }
    end

    context 'with authenticated users' do
      let!(:items) { 4.times.map { Fabricate(:queue_item, user: current_user) } }

      before { get :index }

      it 'assigns queue items for user' do
        expect(assigns(:queue_items)).to match_array(items)
      end

      it 'renders template' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'POST create' do
    before { set_current_user }

    it_behaves_like 'require signin' do
      let(:action) { post :create }
    end

    context 'with authenticated users' do
      let(:video) { Fabricate(:video) }

      it 'creates the queue item that is associated with the video' do
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it 'creates the queue item that is associated with the user' do
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(current_user)
      end

      it 'puts the video as the last one in the queue' do
        video_1 = Fabricate(:video)
        video_2 = Fabricate(:video)
        Fabricate(:queue_item, video: video_1, user: current_user)
        post :create, video_id: video_2.id
        expect(current_user.queue_items.where(video: video_2).first.list_order).to eq(2)
      end

      it 'creates a new queue item if the video is not in user queue' do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it 'does not create a new queue item if the video is in user queue' do
        queue_item = Fabricate(:queue_item, video: video, user: current_user)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it 'redirects user to my queue page' do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
    end
  end

  describe 'POST update_queue' do
    before { set_current_user }

    it_behaves_like 'require signin' do
      let(:action) { post :update_queue }
    end

    context 'with valid inputs' do
      let(:video_1) { Fabricate(:video) }
      let(:video_2) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: current_user, list_order: '1', video: video_1) }
      let(:queue_item2) { Fabricate(:queue_item, user: current_user, list_order: '2', video: video_2) }

      it 'reorders queue items' do
        post :update_queue, queue_items: [{id: queue_item1.id, list_order: '2'}, {id: queue_item2.id, list_order: '1'}]
        expect(current_user.queue_items).to eq([queue_item2, queue_item1])
      end

      it 'normalizes the list_order numbers' do
        post :update_queue, queue_items: [{id: queue_item1.id, list_order: '3'}, {id: queue_item2.id, list_order: '2'}]
        expect(current_user.queue_items.map(&:list_order)).to eq([1, 2])
      end

      it 'redirects to my queue' do
        post :update_queue, queue_items: [{id: queue_item1.id, list_order: '2'}, {id: queue_item2.id, list_order: '1'}]
        expect(response).to redirect_to my_queue_path
      end
    end

    context 'with invalid inputs' do
      let(:video_1) { Fabricate(:video) }
      let(:video_2) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: current_user, list_order: '1', video: video_1) }
      let(:queue_item2) { Fabricate(:queue_item, user: current_user, list_order: '2', video: video_2) }

      it 'redirects to the my queue page' do
        post :update_queue, queue_items: [{id: queue_item1.id, list_order: '3.5'}, {id: queue_item2.id, list_order: '2'}]
        expect(response).to redirect_to my_queue_path
      end
      it 'sets the flash danger message' do
        post :update_queue, queue_items: [{id: queue_item1.id, list_order: '3.5'}, {id: queue_item2.id, list_order: '2'}]
        expect(flash[:danger]).to be_present
      end

      it 'does not change the queue items' do
        post :update_queue, queue_items: [{id: queue_item1.id, list_order: '3'}, {id: queue_item2.id, list_order: '2.1'}]
        expect(queue_item1.reload.list_order).to eq(1)
      end
    end

    context 'with queue items that do not belong to the current user' do
      before { set_current_user }

      it 'does not change the queue items' do
        other_user = Fabricate(:user)
        video = Fabricate(:video)
        queue_item1 =  Fabricate(:queue_item, user: current_user, video: video, list_order: '1')
        queue_item2 = Fabricate(:queue_item, user: other_user, video: video, list_order: '2')
        post :update_queue, queue_items: [{id: queue_item1.id, list_order: '2'}, {id: queue_item2.id, list_order: '1'}]
        expect(queue_item2.reload.list_order).to eq(2)
      end
    end
  end

  describe 'DELETE destroy' do
    before { set_current_user }

    it_behaves_like 'require signin' do
      let(:action) { delete :destroy, id: 1 }
    end

    context 'with authenticated users' do
      let(:queue_item) { Fabricate(:queue_item, user: current_user) }

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

      it 'normalizes the list_order numbers' do
        2.times { |i| Fabricate(:queue_item, user: current_user, list_order: i + 1) }
        queue_item1 = queue_item.update_attributes(list_order: 3)
        queue_item2 = Fabricate(:queue_item, user: current_user, list_order: 4)
        delete :destroy, id: queue_item1
        expect(queue_item2.reload.list_order).to eq(3)
      end

      it 'redirects to my queue page' do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end
    end
  end
end