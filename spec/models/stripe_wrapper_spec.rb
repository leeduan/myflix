require 'spec_helper'

describe StripeWrapper::Charge do
  before { StripeWrapper.set_api_key }

  describe '.create' do
    let(:token) do
      Stripe::Token.create(
        card: {
          number: card_number,
          exp_month: Date.today.month + 1,
          exp_year: Date.today.year + 1,
          cvc: '314'
        }
      ).id
    end
    let(:charge) { StripeWrapper::Charge.create(amount: 100, card: token, description: 'test') }

    context 'with valid card', :vcr do
      let(:card_number) { '4242424242424242' }

      it 'charges the card successfully' do
        expect(charge).to be_successful
      end
    end

    context 'with invalid card', :vcr do
      let(:card_number) { '4000000000000002' }

      it 'does not charge the card successfully' do
        expect(charge).to_not be_successful
      end

      it 'contains an error message' do
        expect(charge.error_message).to eq('Your card was declined.')
      end
    end
  end
end