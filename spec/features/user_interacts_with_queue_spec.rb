require 'spec_helper'

feature 'user interacts with the queue' do
  given(:user) { User.create(email: 'hello@leeduan.com', password: 'password', full_name: 'Lee Duan') }

  scenario 'user adds and reorders videos in the queue' do
    category = Fabricate(:category)
    video_1 = Fabricate(:video, title: 'South Park', category: category)
    video_2 = Fabricate(:video, title: 'Futurama', category: category)
    video_3 = Fabricate(:video, title: 'Family Guy', category: category)

    sign_in(user)

    add_video_to_queue(video_1)
    expect_video_to_be_in_queue(video_1)
    expect(page).to have_content video_1.title

    visit video_path(video_1)
    expect_link_not_to_be_seen('+ My Queue')

    add_video_to_queue(video_2)
    add_video_to_queue(video_3)

    set_video_position(video_1, '3')
    set_video_position(video_2, '1')
    set_video_position(video_3, '2')
    update_queue

    expect_video_position(video_1, '3')
    expect_video_position(video_2, '1')
    expect_video_position(video_3, '2')
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_not_to_be_seen(link_text)
    expect(page).to_not have_content(link_text)
  end

  def update_queue
    click_on 'Update Instant Queue'
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_on '+ My Queue'
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][list_order]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='number']").value).to eq(position.to_s)
  end
end