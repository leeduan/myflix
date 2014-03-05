require 'spec_helper'

describe Relationship do
  it { should belong_to(:leader).class_name('User') }
  it { should belong_to(:follower).class_name('User') }
  it { should validate_presence_of(:leader_id) }
  it { should validate_presence_of(:follower_id) }
  it { should validate_uniqueness_of(:follower_id).scoped_to(:leader_id) }
  it { should validate_uniqueness_of(:leader_id).scoped_to(:follower_id) }

  describe '#follower_is?' do
    let(:current_user) { Fabricate(:user) }
    let(:other_user) { Fabricate(:user) }

    it 'returns true if current user is follower' do
      following = Fabricate(:relationship, leader: other_user, follower: current_user)
      expect(following.follower_is?(current_user)).to eq(true)
    end

    it 'returns false if current user is not follower' do
      following = Fabricate(:relationship, leader: other_user, follower: current_user)
      expect(following.follower_is?(other_user)).to eq(false)
    end
  end
end