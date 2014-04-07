require 'spec_helper'

describe StripeWrapper::Customer do
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
        expect(customer.stripe_id).to be_present
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
        expect(customer.stripe_id).to_not be_present
      end

      it 'sets status of not successful' do
        expect(customer.successful?).to eq(false)
      end

      it 'has an error message' do
        expect(customer.error_message).to be_present
      end
    end
  end

  describe '.retrieve' do
    let(:customer) { StripeWrapper::Customer.retrieve('cus_3ngLzXztv1omPi') }
    let(:invalid_customer) { StripeWrapper::Customer.retrieve('invalid-user') }

    context 'with valid id', :vcr do
      it 'creates a customer' do
        expect(customer).to be_successful
      end
    end

    context 'with invalid id', :vcr do
      it 'does not create a customer' do
        expect(invalid_customer).to_not be_successful
      end

      it 'has an error message' do
        expect(invalid_customer.error_message).to be_present
      end
    end
  end

  describe '#subscription', :vcr do
    let(:customer) { StripeWrapper::Customer.retrieve('cus_3ngLzXztv1omPi') }

    it 'has a subscription' do
      expect(customer.subscription[:name]).to eq('Monthly Premium')
      expect(customer.subscription[:amount]).to eq(999)
      expect(customer.subscription[:next_billind_date]).to be_instance_of(DateTime)
    end
  end

  describe '#cancel_subscription', :vcr do
    let(:customer) { StripeWrapper::Customer.retrieve('cus_3o0HkagC8EB6f5') }

    it 'deletes the subscription' do
      expect(customer.cancel_subscription).to be_present
    end
  end
end
