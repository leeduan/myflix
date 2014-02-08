require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe '#search_by_title' do
    let!(:futurama) { Video.create(title: 'Futurama', description: 'A mediocre show.') }
    let!(:back_to_future) { Video.create(title: 'Back to the Future', description: 'A classic movie!') }

    it 'returns an array of all matches ordered by created_at' do
      Video.search_by_title('Futur').should == [back_to_future, futurama]
    end

    it 'returns an array of one video for a partial match' do
      Video.search_by_title('urama').should == [futurama]
    end

    it 'returns an array of one video for an exact match' do
      Video.search_by_title('Futurama').should == [futurama]
    end

    it 'returns an empty array if there is no match' do
      Video.search_by_title('Hello').should == []
    end

    it 'returns an empty array for a search with an empty string' do
      Video.search_by_title('').should == []
    end
  end
end