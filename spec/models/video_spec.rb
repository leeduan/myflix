require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:url) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should have_many(:queue_items) }

  describe '#search_by_title' do
    let!(:futurama) { Fabricate(:video, title: 'Futurama') }
    let!(:back_to_future) { Fabricate(:video, title: 'Back to the Future') }

    it 'returns an array of all matches ordered by created_at' do
      expect(Video.search_by_title('Futur')).to eq([back_to_future, futurama])
    end

    it 'returns an array of one video for a partial match' do
      expect(Video.search_by_title('urama')).to eq([futurama])
    end

    it 'returns an array of one video for an exact match' do
      expect(Video.search_by_title('Futurama')).to eq([futurama])
    end

    it 'returns an empty array if there is no match' do
      expect(Video.search_by_title('Hello')).to eq([])
    end

    it 'returns an empty array for a search with an empty string' do
      expect(Video.search_by_title('')).to eq([])
    end
  end

  describe '#average_rating' do
    it 'returns nil if there are no reviews' do
      video = Fabricate(:video)
      expect(video.average_rating).to be_nil
    end

    it 'returns a floating number rounded to one decimal point' do
      video = Fabricate(:video)
      video.reviews << Fabricate(:review, rating: 3)
      video.reviews << Fabricate(:review, rating: 1)
      video.reviews << Fabricate(:review, rating: 1)
      expect(video.average_rating).to eq(1.7)
    end

    it 'returns a floating number even if average has no decimal' do
      video = Fabricate(:video)
      video.reviews << Fabricate(:review, rating: 5)
      video.reviews << Fabricate(:review, rating: 5)
      video.reviews << Fabricate(:review, rating: 5)
      expect(video.average_rating).to be_instance_of(Float)
    end

    it 'returns the correct average of all ratings' do
      video = Fabricate(:video)
      review_1 = Fabricate(:review, video: video, rating: 3)
      review_2 = Fabricate(:review, video: video, rating: 3)
      review_3 = Fabricate(:review, video: video, rating: 4)
      expect(video.average_rating).to eq(3.3)
    end
  end

  describe '#exists_in_queue?' do
    it 'returns true if video exists in current user queue' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(video.exists_in_queue?(user)).to eq(true)
    end

    it 'returns false if video does not exist in current user queue' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      2.times { Fabricate(:queue_item, user: user) }
      expect(video.exists_in_queue?(user)).to eq(false)
    end
  end
end