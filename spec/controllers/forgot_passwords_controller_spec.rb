require 'spec_helper'

describe ForgotPasswordsController do
  describe 'GET index' do
    it_behaves_like 'redirect home current user' do
      let(:action) { get :new }
    end

    it 'renders the new template' do
      post :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    after { ActionMailer::Base.deliveries.clear }

    it_behaves_like 'redirect home current user' do
      let(:action) { post :create }
    end

    context 'with nonexisting user email address' do
      it 'does not send an email' do
        post :create, email: 'invalid@example.com'
        expect(ActionMailer::Base.deliveries).to eq([])
      end
    end

    context 'with existing user email address' do
      let(:user) { Fabricate(:user) }
      before { post :create, email: user.email }

      it 'creates a user password token' do
        expect(user.reload.password_token).to_not be_nil
      end

      it 'sends an email with the user password token' do
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include(user.password_token)
      end

      it 'sends the email to the correct person' do
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([user.email])
      end
    end

    it 'redirects to confirm password reset page' do
      post :create
      expect(response).to redirect_to confirm_password_reset_path
    end
  end

  describe 'GET confirm' do
    it_behaves_like 'redirect home current user' do
      let(:action) { get :confirm }
    end

    it 'renders the show template' do
      get :confirm
      expect(response).to render_template :confirm
    end
  end
end