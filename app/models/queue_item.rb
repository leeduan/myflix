class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true, uniqueness: { scope: :video_id }
  validates :video_id, presence: true, uniqueness: { scope: :user_id }
  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    index = self.video.reviews.index { |review| review.user == self.user }
    rating = self.video.reviews[index].rating if index

    if rating && rating > 1
      "#{rating} Stars"
    elsif rating
      "#{rating} Star"
    end
  end

  def category_name
    category.name
  end
end