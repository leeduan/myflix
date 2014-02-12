require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order('created_at DESC') }

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
      rating = 0.0
      count = 0
      5.times do
        review = Fabricate(:review)
        rating += review.rating.to_f
        count += 1
        video.reviews << review
      end
      expect(video.average_rating).to eq((rating/count).round(1))
    end
  end
end