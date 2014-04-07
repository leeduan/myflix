class BillingsController < ApplicationController
  before_action :require_user
  before_action :customer

  def index
    if customer.successful?
      @subscription = customer.subscription
      @payments = current_user.payments.limit(10).order('created_at DESC')
    end
  end

  def cancel
    customer.cancel_subscription
    current_user.update_column('suspended', true)
    session[:user_id] = nil
    flash[:info] = 'You have cancelled your subscription with MyFLiX. Please contact customer service to reactivate.'
    redirect_to front_path
  end

  private

  def customer
    @customer ||= StripeWrapper::Customer.retrieve(current_user.stripe_id)
  end
end
