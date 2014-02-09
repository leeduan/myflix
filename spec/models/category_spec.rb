require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos' do
    let!(:category) { Fabricate(:category) }
    subject { category.recent_videos }

    context 'videos descending created at order' do
      before do
        @third_video = Fabricate(:video, created_at: 2.day.ago, category: category)
        @first_video = Fabricate(:video, category: category)
        @second_video = Fabricate(:video, created_at: 1.day.ago, category: category)
      end
      it { should == [@first_video, @second_video, @third_video] }
    end

    context 'no videos' do
      it { should == [] }
    end

    context 'less than six videos' do
      before do
        2.times { |i| Fabricate(:video, category: category) }
      end
      it { should have(2).items }
    end

    context 'multiple videos' do
      before do
        6.times { |i| Fabricate(:video, category: category) }
      end
      it { should have(6).items }
    end

    context 'more than six videos' do
      before do
        6.times { |i| Fabricate(:video, category: category) }
        @first_video = Fabricate(:video, created_at: 1.day.ago, category: category)
      end
      it { should have(6).items }
      it { should_not include(@first_video) }
    end
  end
end

