require 'spec_helper'

describe SessionsController do

  describe 'GET new' do
    before { set_current_user }
    it 'redirects user to home if signed in' do
      get :new
      expect(response).to redirect_to home_path
    end

    it 'renders template if not signed in' do
      clear_current_user
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    context 'params valid' do
      before do
        set_current_user
        post :create, email: current_user.email, password: 'password'
      end

      it 'sets user session' do
        expect(session[:user_id]).to eq(current_user.id)
      end

      it 'sets the notice' do
        expect(flash[:info]).not_to be_blank
      end

      it 'redirects to home' do
        expect(response).to redirect_to home_path
      end
    end

    context 'params invalid' do
      before { post :create }

      it 'does not set session' do
        expect(session[:user_id]).to be_nil
      end

      it 'sets the danger notice' do
        expect(flash[:danger]).to_not be_blank
      end

      it 'redirects to signin' do
        expect(response).to redirect_to signin_path
      end
    end

    context 'suspended user' do
      before do
        user = Fabricate(:user, password: 'password', suspended: true)
        post :create, email: user.email, password: 'password'
      end

      it 'does not set session' do
        expect(session[:user_id]).to be_nil
      end

      it 'sets the danger notice' do
        expect(flash[:danger]).to be_present
      end

      it 'redirects to front path' do
        expect(response).to redirect_to front_path
      end
    end
  end

  describe 'GET destroy' do
    before { get :destroy }

    it 'removes session' do
      expect(session[:user_id]).to be_nil
    end

    it 'sets the notice' do
      expect(flash[:info]).not_to be_blank
    end

    it 'redirects to signin' do
      expect(response).to redirect_to signin_path
    end
  end
end
