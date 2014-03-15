class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items
  validates_presence_of :title, :description, :url

  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def average_rating
    if reviews.count > 0
      average = reviews.inject(0.0){|sum, review| sum + review.rating.to_f } / reviews.count
      average.round(1)
    end
  end

  def exists_in_queue?(current_user)
    queue_items.any? { |queue_item| queue_item.user == current_user }
  end
end