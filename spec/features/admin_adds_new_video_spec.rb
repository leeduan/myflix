require 'spec_helper'

feature 'admin adds new video' do
  given(:admin) { Fabricate(:user, admin: true) }
  given(:user) { Fabricate(:user) }

  scenario 'admin successfully adds new video and regular user sees video' do
    Fabricate(:category, name: 'Comedies')
    sign_in(admin)
    visit new_admin_video_path

    fill_in 'Title', with: 'New Test Video'
    select 'Comedies', from: 'Category'
    fill_in 'Description', with: 'New test video description.'
    attach_file 'Large Cover', 'spec/support/uploads/monk_large.jpg'
    attach_file 'Small Cover', 'spec/support/uploads/monk.jpg'
    fill_in 'Video URL', with: 'http://youtube.com/fake-video.mp4'
    click_on 'Add Video'

    sign_out
    sign_in(user)

    click_on_video_on_home_page(Video.first)
    expect(page).to have_content('New Test Video')
    expect(page).to have_selector("img[src='/uploads/video/large_cover/1/thumb_monk_large.jpg']")
    expect(page).to have_selector("a[href='http://youtube.com/fake-video.mp4']")
  end
end