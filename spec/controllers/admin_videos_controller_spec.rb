require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'require admin' do
      let(:action) { get :new }
    end

    context 'user is admin' do
      before { set_current_admin }

      it 'assigns @categories' do
        get :new
        expect(assigns(:categories)).to eq(Category.all)
      end

      it 'assigns @video with new video' do
        get :new
        expect(assigns(:video)).to be_new_record
        expect(assigns(:video)).to be_instance_of(Video)
      end

      it 'renders the new template' do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST create' do
    it_behaves_like 'require admin' do
      let(:action) { get :new }
    end

    context 'with valid input' do
      before { set_current_admin }

      it 'creates a new video' do
        post :create, video: Fabricate.attributes_for(:video)
        expect(Video.count).to eq(1)
      end

      it 'sets the flash info message' do
        post :create, video: Fabricate.attributes_for(:video)
        expect(flash[:info]).to be_present
      end

      it 'redirects to new video page' do
        post :create, video: Fabricate.attributes_for(:video)
        expect(response).to redirect_to new_admin_video_path
      end
    end

    context 'with invalid input' do
      before { set_current_admin }

      it 'assigns @categories' do
        post :create, video: Fabricate.attributes_for(:video, description: '')
        expect(assigns(:categories)).to eq(Category.all)
      end

      it 'assigns @video' do
        post :create, video: Fabricate.attributes_for(:video, description: '')
        expect(assigns(:video)).to be_instance_of(Video)
        expect(assigns(:video)).to be_new_record
      end

      it 'does not create a new video' do
        post :create, video: Fabricate.attributes_for(:video, description: '')
        expect(Video.count).to eq(0)
      end

      it 'sets the flash danger message' do
        post :create, video: Fabricate.attributes_for(:video, description: '')
        expect(flash[:danger]).to be_present
      end

      it 'renders the new video template' do
        post :create, video: Fabricate.attributes_for(:video, description: '')
        expect(response).to render_template :new
      end
    end
  end
end