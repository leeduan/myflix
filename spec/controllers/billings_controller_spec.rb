require 'spec_helper'

describe BillingsController do
  describe 'GET index' do
    before { set_current_user }

    it_behaves_like 'require signin' do
      let(:action) { get :index }
    end

    context 'with successful customer retrieval' do
      before do
        subscription = double(
          :subscription,
          name: 'Monthly Premium',
          amount: 999,
          next_billind_date: DateTime.new(2014,2,3)
        )
        allow_any_instance_of(StripeWrapper::Customer).to receive(:subscription).and_return(subscription)
        allow_any_instance_of(StripeWrapper::Customer).to receive(:successful?).and_return(true)
      end

      it 'assigns @subscription' do
        2.times { Fabricate(:payment, user: current_user) }
        get :index
        expect(assigns(:subscription)).to be_present
      end

      it 'assigns @payments' do
        2.times { Fabricate(:payment, user: current_user) }
        get :index
        expect(assigns(:payments).count).to eq(2)
      end

      it 'assigns up to ten payments in descending order' do
        12.times { Fabricate(:payment, user: current_user) }
        get :index
        expect(assigns(:payments)).to eq(Payment.last(10).reverse)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end
    end

    context 'with unsuccessful customer retrieval' do
      before do
        allow_any_instance_of(StripeWrapper::Customer).to receive(:successful?).and_return(false)
      end

      it 'does not receive call to subscription' do
        expect_any_instance_of(StripeWrapper::Customer).to_not receive(:subscription)
        get :index
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'POST cancel' do
    before { set_current_user }

    it_behaves_like 'require signin' do
      let(:action) { get :index }
    end

    context 'with successful customer retrieval' do
      before do
        allow_any_instance_of(StripeWrapper::Customer).to receive(:cancel_subscription)
        allow_any_instance_of(StripeWrapper::Customer).to receive(:successful?).and_return(true)
        post :cancel
      end

      it 'suspends the account' do
        expect(User.first.suspended).to eq(true)
      end

      it 'signs the user out' do
        expect(session[:user_id]).to eq(nil)
      end

      it 'displays a flash message' do
        expect(flash[:info]).to be_present
      end

      it 'redirects to front path' do
        expect(response).to redirect_to front_path
      end
    end
  end
end
