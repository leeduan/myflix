require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos' do
    let(:category) { Fabricate(:category) }
    let(:should) { category.recent_videos }

    context 'videos descending created at order' do
      before do
        @video_3 = Fabricate(:video, created_at: 2.day.ago)
        @video_1 = Fabricate(:video)
        @video_2 = Fabricate(:video, created_at: 1.day.ago)
      end
      it { should == [@video_1, @video_2, @video_3] }
    end

    context 'no videos' do
      it { should == [] }
    end

    context 'less than six videos' do
      before do
        2.times { |i| Fabricate(:video) }
      end
      it { should.count == 2 }
    end

    context 'multiple videos' do
      before do
        6.times { |i| Fabricate(:video) }
      end
      it { should.count == 6 }
    end

    context 'more than six videos' do
      before do
        6.times { |i| Fabricate(:video) }
        @first_video = Fabricate(:video, created_at: 1.day.ago)
      end
      it { should.count == 6 }
      it { should.should_not == @first_video}
    end
  end
end

