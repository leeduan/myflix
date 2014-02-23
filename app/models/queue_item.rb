class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true, uniqueness: { scope: :video_id }
  validates :video_id, presence: true, uniqueness: { scope: :user_id }
  validates_numericality_of :list_order, { only_integer: true }

  delegate :category, to: :video
  delegate :reviews, to: :video
  delegate :title, to: :video, prefix: :video

  def self.already_exists?(video, current_user)
    find_by(user: current_user, video: video)
  end

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    new_rating = [1, 2, 3, 4, 5].include?(new_rating.to_f) ? new_rating : nil
    if review
      review.update_attribute(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_name
    category.name
  end

  def user_has_access?(current_user)
    user == current_user
  end

  def review
    @review ||= Review.where(user: user, video: video).first
  end
end