require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:video_id) }

  describe '#video_title' do
    it 'returns the associated video title' do
      video = Fabricate(:video, title: 'South Park')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq('South Park')
    end
  end

  describe '#rating' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it 'returns nil if no review by current user' do
      review = Fabricate(:review)
      queue_item = Fabricate(:queue_item)
      expect(queue_item.rating).to be_nil
    end

    it 'returns 1 star if rating is 1 Star for current user' do
      review = Fabricate(:review, rating: 1, user: user)
      video.reviews << review
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq('1 Star')
    end

    it 'returns pluralized star if review is higher than 1 star' do
      review = Fabricate(:review, rating: 5, user: user)
      video.reviews << review
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq('5 Stars')
    end
  end

  describe '#category_name' do
    it 'returns the associated video category name' do
      category = Fabricate(:category, name: 'Comedies')
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq('Comedies')
    end
  end

  describe '#category' do
    it 'returns the associated video category' do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end