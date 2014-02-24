require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should have_many(:queue_items).order('list_order') }
  it { should have_many(:following_relationships) }
  it { should have_many(:leading_relationships) }

  describe '#follows?' do
    let(:current_user) { Fabricate(:user) }
    let(:other_user) { Fabricate(:user) }

    it 'returns true if current user is already following leader' do
      relationship = Fabricate(:relationship, leader: other_user, follower: current_user)
      expect(current_user.follows?(other_user)).to eq(true)
    end

    it 'returns false if current user is not following leader' do
      relationship = Fabricate(:relationship, leader: current_user, follower: other_user)
      expect(current_user.follows?(other_user)).to eq(false)
    end
  end

  describe '#can_follow?' do
    let(:current_user) { Fabricate(:user) }
    let(:other_user) { Fabricate(:user) }

    it 'returns true if current user is not following leader and is not the leader' do
      expect(current_user.can_follow?(other_user)).to eq(true)
    end

    it 'returns false if current user is the leader' do
      expect(current_user.can_follow?(current_user)).to eq(false)
    end

    it 'returns false if current user is already following leader' do
      relationship = Fabricate(:relationship, leader: other_user, follower: current_user)
      expect(current_user.can_follow?(other_user)).to eq(false)
    end
  end

  describe '#followers_count' do
    let(:current_user) { Fabricate(:user) }
    let(:user_1) { Fabricate(:user) }
    let(:user_2) { Fabricate(:user) }
    let(:user_3) { Fabricate(:user) }

    it 'returns number of followers a user has' do
      Fabricate(:relationship, leader: current_user, follower: user_1)
      Fabricate(:relationship, leader: current_user, follower: user_2)
      Fabricate(:relationship, leader: current_user, follower: user_3)
      expect(current_user.followers_count).to eq(3)
    end
  end
end