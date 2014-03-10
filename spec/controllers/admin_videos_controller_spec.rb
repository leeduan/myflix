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
end