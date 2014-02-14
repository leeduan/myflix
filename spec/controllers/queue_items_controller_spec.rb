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
end