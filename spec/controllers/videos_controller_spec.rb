require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    it 'sets @video for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it 'redirects the user to the signin page for unauthenticated users' do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to signin_path
    end
  end

  describe 'POST search' do
    it 'sets @videos from search term for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      search_terms = Faker::Lorem.words.join(' ')
      video = Fabricate(:video, title: search_terms)
      post :search, search_terms: search_terms[0..search_terms.size/2]
      expect(assigns(:videos)).to eq([video])
    end

    it 'redirects the user to the signin page for unauthenticated users' do
      search_terms = Faker::Lorem.words.join(' ')
      video = Fabricate(:video, title: search_terms)
      post :search, search_terms: search_terms
      expect(response).to redirect_to signin_path
    end
  end

end