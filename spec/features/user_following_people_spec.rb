require 'spec_helper'

feature 'user following people' do
  given(:current_user) { Fabricate(:user) }
  given(:other_user) { Fabricate(:user) }

  scenario 'current user follows and unfollows another user' do
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    video.reviews << Fabricate(:review, user: other_user)

    sign_in(current_user)

    click_on_video_on_home_page(video)
    visit_user_profile(other_user)
    expect(page).to have_content(other_user.full_name)

    follow_user
    expect(page).to have_content(other_user.full_name)

    unfollow_user
    expect(page).to_not have_content(other_user.full_name)
  end

  def visit_user_profile(user)
    click_on user.full_name
  end

  def follow_user
    click_on 'Follow'
  end

  def unfollow_user
    find("a[href='/relationships/#{current_user.following_relationships.first.id}']").click
  end
end