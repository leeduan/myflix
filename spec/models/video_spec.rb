require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: 'The Simpsons', description: 'An American adult animated sitcom created by Matt Groening for the Fox Broadcasting Company.', small_cover_url: 'south_park', large_cover_url: 'monk_large', category_id: '1')
    video.save
    Video.find_by(title: 'The Simpsons').title.should == 'The Simpsons'
  end
end