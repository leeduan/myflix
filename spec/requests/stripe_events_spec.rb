require 'spec_helper'

describe 'Create payment on successful charge' do
  let(:event_data) do
    {
      id: "evt_103l6B2ZsJylVlgJpEEjyhWa",
      created: 1396151497,
      livemode: false,
      type: "charge.succeeded",
      data: {
        object: {
          id: "ch_103l6B2ZsJylVlgJNBMBQrfm",
          object: "charge",
          created: 1396151496,
          livemode: false,
          paid: true,
          amount: 999,
          currency: "usd",
          refunded: false,
          card: {
            id: "card_103l6B2ZsJylVlgJ7y67uAog",
            object: "card",
            last4: "4242",
            type: "Visa",
            exp_month: 3,
            exp_year: 2014,
            fingerprint: "kiMCSaHezC1MyJis",
            customer: "cus_3l6BAd97mcFJ0G",
            country: "US",
            name: nil,
            address_line1: nil,
            address_line2: nil,
            address_city: nil,
            address_state: nil,
            address_zip: nil,
            address_country: nil,
            cvc_check: "pass",
            address_line1_check: nil,
            address_zip_check: nil
          },
          captured: true,
          refunds: [

          ],
          balance_transaction: "txn_103l6B2ZsJylVlgJva011TyO",
          failure_message: nil,
          failure_code: nil,
          amount_refunded: 0,
          customer: "cus_3l6BAd97mcFJ0G",
          invoice: "in_103l6B2ZsJylVlgJYKDW8Fqz",
          description: nil,
          dispute: nil,
          metadata: {
          },
          statement_description: "Monthly MyFLiX"
        }
      },
      object: "event",
      pending_webhooks: 1,
      request: "iar_3l6BKbMvzMDb4s"
    }
  end
  let!(:user) { Fabricate(:user, stripe_id: "cus_3l6BAd97mcFJ0G") }
  before { post 'stripe-events', event_data }

  it 'creates a payment with the webhook from stripe for charge succeeded', :vcr do
    expect(Payment.count).to eq(1)
  end

  it 'creates the payment associated with user', :vcr do
    expect(Payment.first.user).to eq(user)
  end

  it 'creates the payment with the amount', :vcr do
    expect(Payment.first.amount).to eq(999)
  end

  it 'creates the payment with the reference id', :vcr do
    expect(Payment.first.reference_id).to eq('ch_103l6B2ZsJylVlgJNBMBQrfm')
  end
end