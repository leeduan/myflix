class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true, uniqueness: { scope: :video_id }
  validates :video_id, presence: true, uniqueness: { scope: :user_id }
  validates_numericality_of :list_order, { only_integer: true, less_than: 6, greater_than: 0 }

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
    return unless new_rating_valid?(new_rating)
    if review
      review.update_column(:rating, new_rating == '' ? nil : new_rating)
    elsif new_rating.present?
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_name
    category.name
  end

  def owned_by?(current_user)
    user == current_user
  end

  def review
    @review ||= Review.find_by(user: user, video: video)
  end

  private

  def new_rating_valid?(rating)
    (1..5).include?(rating.to_i) || rating == ''
  end
end