require 'spec_helper'

describe StripeWrapper::Charge do
  before { StripeWrapper.set_api_key }

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

  context 'with valid card' do
    let(:card_number) { '4242424242424242' }

    it 'charges the card successfully', :vcr do
      expect(VCR.use_cassette('valid credit card charge') { charge }).to be_successful
    end
  end

  context 'with invalid card' do
    let(:card_number) { '4000000000000002' }

    VCR.use_cassette('stripe_invalid_card') do
      it 'does not charge the card successfully' do
        expect(VCR.use_cassette('invalid credit card charge') { charge }).to_not be_successful
      end

      it 'contains an error message' do
        expect(VCR.use_cassette('invalid credit card charge') { charge.error_message }).to eq('Your card was declined.')
      end
    end
  end
end