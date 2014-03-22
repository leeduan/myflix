class VideoDecorator < Draper::Decorator
  delegate_all

  def average_rating_text
    object.average_rating.present? ? "#{object.average_rating} / 5.0" : 'N/A'
  end
end