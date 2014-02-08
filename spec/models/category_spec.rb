require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos' do
    let(:category) { Category.create(name: 'action') }
    let(:should) { category.recent_videos }

    context 'videos descending created at order' do
      before do
        @star_wars = category.videos.create(title: 'Star Wars', description: 'Great video!')
        @star_trek = category.videos.create(title: 'Star Trek', description: 'Great video!', created_at: 1.day.ago)
        @rock_star = category.videos.create(title: 'Thor',      description: 'Great video!', created_at: 2.day.ago)
      end
      it { should == [@star_wars, @star_trek, @rock_star] }
    end

    context 'no videos' do
      it { should == [] }
    end

    context 'less than six videos' do
      before do
        2.times { |i| category.videos.create(title: "Star Wars #{i}", description: 'Great video!') }
      end
      it { should.count == 2 }
    end

    context 'multiple videos' do
      before do
        6.times { |i| category.videos.create(title: "Star Wars #{i}", description: 'Great video!') }
      end
      it { should.count == 6 }
    end

    context 'more than six videos' do
      before do
        6.times { |i| category.videos.create(title: "Star Wars #{i}", description: 'Great video!') }
        @first_video = category.videos.create(title: "Yesterday", created_at: 1.day.ago)
      end
      it { should.count == 6 }
      it { should.should_not == @first_video}
    end
  end
end

