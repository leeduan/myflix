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

    context 'with valid input' do
      before { post :create, user: Fabricate.attributes_for(:user) }

      it 'creates the user' do
        expect(User.count).to eq(1)
      end

      it 'shows flash info message' do
        expect(flash[:info]).to be_present
      end

      it 'redirects the user to signin path' do
        expect(response).to redirect_to signin_path
      end
    end

    context 'with invitation' do
      let(:sender) { current_user }

      before do
        set_current_user
        invitation = Fabricate(:invitation, sender: sender)
        clear_current_user
        post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email, invitation: invitation)
        set_current_user(User.find_by(invitation: invitation))
      end

      it 'makes the user follow the sender' do
        expect(current_user.follows?(sender)).to eq(true)
      end

      it 'makes the inviter follow the user' do
        expect(sender.follows?(current_user)).to eq(true)
      end

      it 'expires the invitation upon creation of user' do
        expect(Invitation.first.token).to eq(nil)
      end
    end

    context 'email sending' do
      let(:user_attributes) { Fabricate.attributes_for(:user) }

      it 'sends out the email with valid inputs' do
        post :create, user: user_attributes
        expect(Sidekiq::Extensions::DelayedMailer.jobs).to_not be_empty
      end

      it 'sends out the email to the right recipient with valid inputs' do
        post :create, user: user_attributes
        message = Sidekiq::Extensions::DelayedMailer.jobs.last['args'][0]
        expect(message).to include(user_attributes[:email])
      end

      it 'sends the email containing the user name with valid inputs' do
        post :create, user: user_attributes
        message = Sidekiq::Extensions::DelayedMailer.jobs.last['args'][0]
        expect(message).to include(user_attributes[:full_name])
      end

      it 'does not send out email with invalid inputs' do
        post :create, user: { email: 'invalid@example.com' }
        message = Sidekiq::Extensions::DelayedMailer.jobs
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