require 'spec_helper'

describe RelationshipsController do
  describe 'GET index' do
    before { set_current_user }

    it_behaves_like 'require signin' do
      let(:action) { get :index }
    end

    it 'sets @relationships to the current user following relationships' do
      other_user = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: other_user, follower: current_user)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'POST create' do
    before { set_current_user }
    let(:other_user) { Fabricate(:user) }

    it_behaves_like 'require signin' do
      let(:action) { post :create, leader_id: 1 }
    end

    it 'creates a relationship that the current user follows the leader' do
      post :create, leader_id: other_user.id
      expect(current_user.following_relationships.first.leader).to eq(other_user)
    end

    it 'redirects to people path' do
      post :create, leader_id: other_user.id
      expect(response).to redirect_to people_path
    end
  end

  describe 'DELETE destroy' do
    before { set_current_user }
    let(:other_user) { Fabricate(:user) }

    it_behaves_like 'require signin' do
      let(:action) { delete :destroy, id: 1 }
    end

    it 'deletes the relationship if current user is the follower' do
      relationship = Fabricate(:relationship, leader: other_user, follower: current_user)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it 'does not remove the relationship if current user is not the follower' do
      another_user = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: another_user, follower: other_user)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end

    it 'redirects to people path' do
      relationship = Fabricate(:relationship, leader: other_user, follower: current_user)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end
  end
end