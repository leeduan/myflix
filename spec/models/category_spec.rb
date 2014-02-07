require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos' do
    it 'returns the videos in the reverse chronological order by created at' do
      action    = Category.create(name: 'action')
      star_wars = action.videos.create(title: 'Star Wars', description: 'Great video!')
      star_trek = action.videos.create(title: 'Star Trek', description: 'Great video!', created_at: 1.day.ago)
      rock_star = action.videos.create(title: 'Thor', description: 'Great video!', created_at: 2.day.ago)
      expect(action.recent_videos).to eq([star_wars, star_trek, rock_star])
    end
    it 'returns an empty array if the category does not have any videos' do
      action    = Category.create(name: 'action')
      expect(action.recent_videos).to eq([])
    end
    it 'returns all videos if total is less than six' do
      action    = Category.create(name: 'action')
      star_wars = action.videos.create(title: 'Star Wars', description: 'Great video!')
      star_trek = action.videos.create(title: 'Star Trek', description: 'Great video!')
      expect(action.recent_videos.count).to eq(2)
    end
    it 'returns 6 videos if there are more than 6 videos' do
      action    = Category.create(name: 'action')
      7.times { |i| action.videos << Video.create(title: "vid_#{i}", description: 'Great video!') }
      expect(action.recent_videos.count).to eq(6)
    end
    it 'returns the most recent 6 videos' do
      action    = Category.create(name: 'action')
      6.times { |i| action.videos << Video.create(title: "vid_#{i}", description: 'Great video!') }
      yesterday = action.videos << Video.create(title: "Yesterday", created_at: 1.day.ago)
      expect(action.recent_videos).not_to include(yesterday)
    end
  end
end

