module StripeWrapper
  class Customer
    attr_reader :customer, :status, :error

    def self.create(options={})
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

    def stripe_id
      customer[:id] if customer
    end

    def error_message
      error.message
    end
  end

  class Payment
    def call(event)
      charge = event.data.object
      user = User.find_by(stripe_id: charge.customer)

      if event.type == 'charge.succeeded'
        user.payments.create(user: user, amount: charge.amount, reference_id: charge.id)
      elsif event.type == 'charge.failed'
        user.update_columns(suspended: true)
      end
    end
  end
end