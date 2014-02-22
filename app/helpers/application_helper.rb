module ApplicationHelper
  def options_for_video_reviews(selected=nil)
    options_for_select([5,4,3,2,1].map { |num| [pluralize(num, 'Star'), num]}, selected)
  end

  def avatar_url(user, size)
    "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}.png?s=#{size}"
  end
end