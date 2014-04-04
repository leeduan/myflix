Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded', StripeWrapper::Payment.new
  events.subscribe 'charge.failed', StripeWrapper::Payment.new
end