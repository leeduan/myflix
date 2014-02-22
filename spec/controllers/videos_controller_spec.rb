require 'spec_helper'

describe VideosController do
  before { set_current_user }

  it_behaves_like 'require_signin' do
    let(:action) { get :show, id: 1 }
  end

  describe 'GET show' do
    it 'sets @video for authenticated users' do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it 'sets @review for authenticated users' do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:review)).to be_new_record
      expect(assigns(:review)).to be_instance_of(Review)
    end

    it 'sets @reviews for authenticated users' do
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
  end

  describe 'POST search' do
    before { set_current_user }

    it_behaves_like 'require_signin' do
      let(:action) { get :search, search_terms: 'futur' }
    end

    it 'sets @videos from search term for authenticated users' do
      search_terms = Faker::Lorem.words.join(' ')
      video = Fabricate(:video, title: search_terms)
      post :search, search_terms: search_terms[0..search_terms.size / 2]
      expect(assigns(:videos)).to eq([video])
    end
  end
end