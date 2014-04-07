class User < ActiveRecord::Base
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items, -> { order('list_order') }
  has_many :following_relationships, class_name: 'Relationship', foreign_key: :follower_id
  has_many :leading_relationships, class_name: 'Relationship', foreign_key: :leader_id
  has_many :sent_invitations, class_name: 'Invitation', foreign_key: :sender_id
  has_many :payments
  belongs_to :invitation

  validates :email, presence: true, uniqueness: { case_sensitive: true }
  validates :password, presence: true, on: :create
  validates :password, presence: true, confirmation: true, on: :update
  validates :password_confirmation, presence: true, on: :update
  validates_presence_of :full_name
  has_secure_password validations: false

  def follow(leader)
    following_relationships.create(leader: leader) if can_follow?(leader)
  end

  def follows?(leader)
    following_relationships.exists?(leader: leader)
  end

  def can_follow?(leader)
    !(follows?(leader) || self == leader)
  end

  def can_edit?(user)
    self == user
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

  def generate_password_token
    self.update_column(:password_token, SecureRandom.urlsafe_base64)
  end
end
