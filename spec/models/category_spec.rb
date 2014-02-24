require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos' do
    let(:category) { Fabricate(:category) }

    it 'returns array of videos descending created at order' do
      video_3 = Fabricate(:video, created_at: 2.day.ago, category: category)
      video_1 = Fabricate(:video, category: category)
      video_2 = Fabricate(:video, created_at: 1.day.ago, category: category)
      expect(category.recent_videos).to eq([video_1, video_2, video_3])
    end

    it 'returns an empty array if category contains no videos' do
      expect(category.recent_videos).to eq([])
    end

    it 'returns multiple videos up to six if category has up to six' do
      6.times { Fabricate(:video, category: category) }
      expect(category.recent_videos.count).to eq(6)
    end

    it 'returns six videos when there are more than six videos' do
      6.times { Fabricate(:video, category: category) }
      video_1 = Fabricate(:video, created_at: 1.day.ago, category: category)
      expect(category.recent_videos.count).to eq(6)
      expect(category.recent_videos).to_not include(video_1)
    end
  end
end

