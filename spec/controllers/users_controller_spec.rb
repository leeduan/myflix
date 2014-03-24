require 'spec_helper'

describe UsersController do
  describe 'GET new' do

    it_behaves_like 'redirect home current user' do
      let(:action) { get :new }
    end

    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
      expect(assigns(:user)).not_to eq(User.first)
    end
  end

  describe 'GET new_with_invitation' do
    before { set_current_user }
    let!(:invitation) { Fabricate(:invitation, sender: current_user) }

    it_behaves_like 'redirect home current user' do
      let(:action) { get :new }
    end

    context 'valid token' do
      it 'sets @user' do
        clear_current_user
        get :new_with_invitation, token: invitation.token
        expect(assigns(:user)).to be_a_new(User)
        expect(assigns(:user)).not_to eq(User.first)
      end

      it 'sets @user.email if passed valid token' do
        clear_current_user
        get :new_with_invitation, token: invitation.token
        expect(assigns(:user).email).to eq(invitation.recipient_email)
      end

      it 'sets @user.invitation_id if passed valid token' do
        clear_current_user
        get :new_with_invitation, token: invitation.token
        expect(assigns(:user).invitation_id).to eq(invitation.id)
      end

      it 'renders the new template' do
        clear_current_user
        get :new_with_invitation, token: invitation.token
        expect(response).to render_template :new
      end
    end

    context 'invalid token' do
      it 'redirects to invalid token path' do
        clear_current_user
        get :new_with_invitation, token: 'invalid_token'
        expect(response).to redirect_to expired_token_path
      end
    end
  end

  describe 'POST create' do
    it_behaves_like 'redirect home current user' do
      let(:action) { get :new }
    end

    context 'successful user registration' do
      before do
        result = double(:registration_result, successful?: true)
        allow_any_instance_of(UserRegistration).to receive(:register).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'sets @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it 'shows flash info message' do
        expect(flash[:info]).to be_present
      end

      it 'redirects the user to signin path' do
        expect(response).to redirect_to signin_path
      end
    end

    context 'failed user registration' do
      let(:error_message) { 'Your card was declined.'}

      before do
        result = double(:registration_result, successful?: false, error_message: error_message)
        allow_any_instance_of(UserRegistration).to receive(:register).and_return(result)
        post :create, user: { password: 'password' }
      end

      it 'sets @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it 'shows flash danger message' do
        expect(flash[:danger]).to be_present
        expect(flash[:danger]).to eq(error_message)
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