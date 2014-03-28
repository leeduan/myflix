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
    let(:customer) { StripeWrapper::Customer.create(card: token_id) }

    context 'with valid card', :vcr do
      let(:card_number) { '4242424242424242' }

      it 'creates a customer' do
        expect(customer.customer).to be_present
      end

      it 'creates a subscription' do
        expect(customer.subscription).to be_present
      end

      it 'sets status of successful' do
        expect(customer.successful?).to eq(true)
      end
    end

    context 'with invalid card', :vcr do
      let(:card_number) { '4000000000000002' }

      it 'does not create a customer' do
        expect(customer.customer).to_not be_present
      end

      it 'does not create a subscription' do
        expect(customer.subscription).to_not be_present
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