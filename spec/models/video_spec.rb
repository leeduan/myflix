require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

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
end