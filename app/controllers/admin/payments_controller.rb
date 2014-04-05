class Admin::PaymentsController < AdminsController
  def index
    @payments = Payment.limit(10).order('created_at DESC')
  end
end