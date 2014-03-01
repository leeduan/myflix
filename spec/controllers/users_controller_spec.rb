require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    before { set_current_user }

    it 'sets @user' do
      clear_current_user
      get :new
      expect(assigns(:user)).to be_a_new(User)
      expect(assigns(:user)).not_to eq(User.first)
    end

    it 'redirects the user to home if already signed in' do
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    after { ActionMailer::Base.deliveries.clear }

    context 'with valid input' do
      before { post :create, user: Fabricate.attributes_for(:user) }

      it 'creates the user' do
        expect(User.count).to eq(1)
      end

      it 'redirects the user to home' do
        expect(response).to redirect_to home_path
      end
    end

    context 'email sending' do
      let(:user_attributes) { Fabricate.attributes_for(:user) }

      it 'sends out the email with valid inputs' do
        post :create, user: user_attributes
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it 'sends out the email to the right recipient with valid inputs' do
        post :create, user: user_attributes
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([user_attributes[:email]])
      end

      it 'sends the email containing the user name with valid inputs' do
        post :create, user: user_attributes
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include(user_attributes[:full_name])
      end

      it 'does not send out email with invalid inputs' do
        post :create, user: { email: 'invalid@example.com' }
        message = ActionMailer::Base.deliveries
        expect(message).to eq([])
      end
    end

    context 'with invalid input' do
      before { post :create, user: { password: 'password' } }

      it 'does not create the user' do
        expect(assigns(:user)).not_to eq(User.first)
        expect(User.count).to eq(0)
      end

      it 'sets @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET show' do
    before { set_current_user }

    it_behaves_like 'require signin' do
      let(:action) { get :show, id: 1 }
    end

    it 'sets @user' do
      other_user = Fabricate(:user)
      get :show, id: other_user.id
      expect(assigns(:user)).to eq(other_user)
    end

    it 'renders the show template' do
      get :show, id: 1
      expect(response).to render_template :show
    end
  end
end