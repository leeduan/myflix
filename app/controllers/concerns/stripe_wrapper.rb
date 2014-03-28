module StripeWrapper
  def self.set_api_key
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

  class Customer
    attr_reader :customer, :status
    attr_accessor :subscription, :error

    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        customer = Stripe::Customer.create(card: options[:card])
        subscription = customer.subscriptions.create(plan: ENV['STRIPE_SUBSCRIPTION_PLAN'])
        new(customer: customer, subscription: subscription, status: :success)
      rescue Stripe::CardError => e
        new(status: :error, error: e)
      end
    end

    def initialize(options={})
      @customer = options[:customer]
      @subscription = options[:subscription]
      @status = options[:status]
      @error = options[:error]
    end

    def successful?
      status == :success
    end

    def error_message
      error.message
    end
  end
end