require 'spec_helper'

describe ResetPasswordsController do
  describe 'GET show' do
    it_behaves_like 'redirect home current user' do
      let(:action) { get :show, id: '' }
    end

    context 'with valid token' do
      let(:token) { 'r2nd3mt0k8n' }
      let(:user) { Fabricate(:user, password_token: token)}

      it 'assigns @token' do
        get :show, id: user.password_token
        expect(assigns(:token)).to eq(user.password_token)
      end

      it 'render show template' do
        get :show, id: user.password_token
        expect(response).to render_template :show
      end
    end

    context 'with invalid token' do
      it 'redirects to invalid token page' do
        user = Fabricate(:user, password_token: 'r2nd3mt0k8n')
        get :show, id: 'invalid_token'
        expect(response).to redirect_to expired_token_path
      end
    end
  end

  describe 'PATCH update' do
    it_behaves_like 'redirect home current user' do
      let(:action) { patch :update, id: 'r2nd3mt0k8n' }
    end

    context 'with valid token' do
      let(:token) { 'r2nd3mt0k8n' }
      let(:new_password) { 'r3Pa66w0rD' }
      let!(:user) { Fabricate(:user, password_token: token) }

      before { patch :update, id: token, password: new_password }

      it 'updates user password' do
        expect(user.reload.authenticate(new_password)).to be_instance_of(User)
      end

      it 'sets the flash info message' do
        expect(flash[:info]).to_not be_nil
      end

      it 'redirects to signin page' do
        expect(response).to redirect_to signin_path
      end

      it 'removes the user password token' do
        expect(user.reload.password_token).to be_nil
      end
    end

    context 'with invalid token' do
      it 'redirects to invalid token path' do
        patch :update, id: 'r2nd3mt0k8n', password: 'r3Pa66w0rD'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end