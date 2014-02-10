require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    it 'redirects user to home if signed in' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end

    it 'renders template if not signed in' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    context 'params valid' do
      before do
        @email_address = 'example@example.com'
        @password = 'password'
        @user = Fabricate(:user, email: @email_address, password: @password)
        get :create, email: @email_address, password: @password
      end

      it 'sets user session' do
        expect(session[:user_id]).to eq(@user.id)
      end

      it 'sets the notice' do
        expect(flash[:info]).not_to be_blank
      end

      it 'redirects to home' do
        expect(response).to redirect_to home_path
      end
    end

    context 'params invalid' do
      before do
        Fabricate(:user)
        get :create
      end

      it 'does not set session' do
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
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

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