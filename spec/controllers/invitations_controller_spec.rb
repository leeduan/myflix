require 'spec_helper'

describe InvitationsController do
  describe 'GET new' do
    before { set_current_user }

    it_behaves_like 'require signin' do
      let(:action) { get :new }
    end

    it 'assigns @invitation' do
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end

    it 'renders the invite template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    before { set_current_user }
    after { ActionMailer::Base.deliveries.clear }

    it_behaves_like 'require signin' do
      let(:action) { post :create, Fabricate.attributes_for(:invitation) }
    end

    context 'with valid input' do
      let(:invitation_attributes) { Fabricate.attributes_for(:invitation) }
      before { post :create, invitation: invitation_attributes }

      it 'creates an invitation' do
        expect(Invitation.count).to eq(1)
      end

      it 'shows success message' do
        expect(flash[:info]).to_not be_empty
      end

      it 'redirects to invite page' do
        expect(response).to redirect_to invite_path
      end
    end

    context 'email sending' do
      let(:invitation_attributes) { Fabricate.attributes_for(:invitation) }

      it 'sends an email to the correct recipient' do
        post :create, invitation: invitation_attributes
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([invitation_attributes[:recipient_email]])
      end

      it 'does not send when input not valid' do
        post :create, invitation: { recipient_email: 'invalid@example.com' }
        message = ActionMailer::Base.deliveries.last
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context 'with invalid input' do
      before { post :create, invitation: { recipient_email: 'invalid@example.com' } }

      it 'does not create an invitation' do
        expect(Invitation.count).to eq(0)
      end

      it 'sets flash danger message' do
        expect(flash[:danger]).to_not be_nil
      end

      it 'sets @invitation' do
        expect(assigns(:invitation)).to be_new_record
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end
    end
  end
end