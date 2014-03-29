class Payment < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :amount, :reference_id
end