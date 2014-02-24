class Relationship < ActiveRecord::Base
  belongs_to :leader, class_name: 'User'
  belongs_to :follower, class_name: 'User'
  validates :follower_id, presence: true, uniqueness: { scope: :leader_id }
  validates :leader_id, presence: true, uniqueness: { scope: :follower_id }

  def user_has_access?(current_user)
    follower == current_user
  end
end