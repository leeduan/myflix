require 'spec_helper'

describe SessionsController do
  before { set_current_user }

  describe 'GET new' do
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
      before { post :create, email: current_user.email, password: 'password' }

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
        clear_current_user
        expect(session[:user_id]).to be_nil
      end

      it 'sets the error notice' do
        expect(flash[:danger]).to_not be_blank
      end

      it 'redirects to signin' do
        expect(response).to redirect_to signin_path
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