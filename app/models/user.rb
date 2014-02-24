class User < ActiveRecord::Base
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items, -> { order('list_order') }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  validates_presence_of :full_name
  validates :email, presence: true, uniqueness: { case_sensitive: true }
  validates :password, presence: true, on: :create
  has_secure_password validations: false

  def follows?(leader)
    following_relationships.exists?(leader_id: leader.id)
  end

  def can_follow?(leader)
    !(follows?(leader) || self == leader)
  end

  def followers_count
    leading_relationships.count
  end

  def queue_count
    queue_items.count
  end

  def normalize_queue_item_list_order
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(list_order: index + 1)
    end
  end
end