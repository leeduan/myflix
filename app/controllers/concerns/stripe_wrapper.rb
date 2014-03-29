module StripeWrapper
  def self.set_api_key
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

  class Customer
    attr_reader :customer, :status, :error

    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        customer = Stripe::Customer.create(
          email: options[:user].email,
          card: options[:card],
          plan: ENV['STRIPE_SUBSCRIPTION_PLAN']
        )
        new(customer: customer, status: :success)
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

    def id
      customer && customer[:id]
    end

    def error_message
      error.message
    end
  end
end