require 'spec_helper'

describe Admin::PaymentsController do
  describe 'GET index' do
    it_behaves_like 'require admin' do
      let(:action) { get :index }
    end

    context 'user is admin' do
      before { set_current_admin }

      it 'assigns @payments with last ten payments' do
        12.times { Fabricate(:payment) }
        get :index
        expect(assigns(:payments)).to eq(Payment.last(10).reverse)
      end

      it 'assigns @payments with less than ten payments if ten do not exist' do
        5.times { Fabricate(:payment) }
        get :index
        expect(assigns(:payments)).to eq(Payment.last(5).reverse)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  end
end