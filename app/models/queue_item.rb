class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true, uniqueness: { scope: :video_id }
  validates :video_id, presence: true, uniqueness: { scope: :user_id }
  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :list_order, { only_integer: true }

  def self.already_exists?(video, user)
    find_by user: user, video: video
  end

  def rating
    index = video.reviews.index { |review| review.user == user }
    video.reviews[index].rating if index
  end

  def category_name
    category.name
  end

  def user_has_access?(user)
    user_id == user.id
  end
end