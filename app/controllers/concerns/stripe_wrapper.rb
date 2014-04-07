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

    def self.retrieve(id)
      begin
        customer = Stripe::Customer.retrieve(id)
        new(customer: customer, status: :success)
      rescue Stripe::InvalidRequestError => e
        new(status: :error, error: e)
      end
    end

    def initialize(options={})
      @customer = options[:customer]
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

    def subscription
      subscription_obj = customer[:subscriptions][:data][0]
      {
        name: subscription_obj[:plan][:name],
        amount: subscription_obj[:plan][:amount],
        next_billind_date: DateTime.strptime(subscription_obj[:current_period_end].to_s, '%s') + 1
      } if subscription_obj
    end

    def cancel_subscription
      subscription_id = customer.subscriptions.data[0].try(:id)
      customer.subscriptions.retrieve(subscription_id).delete() if subscription_id
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
        UserMailer.delay.suspended_account(user)
      end
    end
  end
end
