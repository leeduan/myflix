require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:video_id) }
  it { should validate_numericality_of(:list_order).only_integer }

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

    it 'returns rating if user has reviewed video' do
      review = Fabricate(:review, rating: 2, user: user)
      video.reviews << review
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(2)
    end
  end

  describe '#rating=()' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it 'changes the rating of the review if the review is present' do
      review = Fabricate(:review, video: video, rating: 2, user: user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rating = '4'
      expect(Review.first.rating).to eq(4)
    end

    it 'clears the rating of the review if the review is present' do
      review = Fabricate(:review, video: video, rating: 2, user: user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rating = ''
      expect(Review.first.rating).to eq(nil)
    end

    it 'creates a review with the rating if the review is not present' do
      review = Fabricate(:review, video: video, rating: 3, user: user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(Review.first.rating).to eq(3)
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