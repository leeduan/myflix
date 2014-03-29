require 'spec_helper'

describe StripeWrapper::Customer do
  before { StripeWrapper.set_api_key }

  describe '.create' do
    let(:token_id) do
      Stripe::Token.create(
        card: {
          number: card_number,
          exp_month: Date.today.month + 1,
          exp_year: Date.today.year + 1,
          cvc: '314'
        }
      ).id
    end
    let(:user) { Fabricate.build(:user) }
    let(:customer) { StripeWrapper::Customer.create(card: token_id, user: user) }

    context 'with valid card', :vcr do
      let(:card_number) { '4242424242424242' }

      it 'creates a customer' do
        expect(customer).to be_successful
      end

      it 'sets the customer id' do
        expect(customer.id).to be_present
      end

      it 'sets status of successful' do
        expect(customer.successful?).to eq(true)
      end
    end

    context 'with invalid card', :vcr do
      let(:card_number) { '4000000000000002' }

      it 'does not create a customer' do
        expect(customer).to_not be_successful
      end

      it 'does not set the customer id' do
        expect(customer.id).to_not be_present
      end

      it 'sets status of not successful' do
        expect(customer.successful?).to eq(false)
      end

      it 'has an error message' do
        expect(customer.error_message).to be_present
      end
    end
  end
end