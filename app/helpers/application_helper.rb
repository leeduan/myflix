module ApplicationHelper
  def options_for_video_reviews(selected=nil)
    options_for_select([5,4,3,2,1].map { |num| [pluralize(num, 'Star'), num]}, selected)
  end

  def avatar_url(user, size)
    "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}.png?s=#{size}"
  end

  def time_to_date(date)
    if date.instance_of? DateTime
      date.strftime('%m/%d/%Y')
    elsif date.instance_of? ActiveSupport::TimeWithZone
      date.to_datetime.strftime('%m/%d/%Y')
    end
  end

  def month_from_date(date)
    time_to_date(date + 1.month - 1.day)
  end
end
