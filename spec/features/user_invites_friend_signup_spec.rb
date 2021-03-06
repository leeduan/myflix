require 'spec_helper'

feature 'user invites friend signup', :js do
  given(:sender) { Fabricate(:user) }
  given(:invite_attributes) { Fabricate.attributes_for(:invitation) }
  given(:friend_attributes) { Fabricate.attributes_for(:user, email: invite_attributes[:recipient_email]) }

  scenario 'user successfully invites friend and friend signs up', :vcr do
    sign_in(sender)
    send_friend_invitation
    sign_out

    friend_reads_and_follows_email
    friend_creates_account
    friend_signs_in

    signed_in_user_should_follow(sender.full_name)
    sign_out

    sign_in(sender)
    signed_in_user_should_follow(friend_attributes[:full_name])

    clear_emails
  end

  def send_friend_invitation
    visit invite_path
    fill_in "Friend's Name", with: invite_attributes[:recipient_name]
    fill_in "Friend's Email Address", with: invite_attributes[:recipient_email]
    fill_in 'Invitation Message', with: invite_attributes[:message]
    click_button 'Send Invitation'
  end

  def friend_reads_and_follows_email
    open_email(invite_attributes[:recipient_email])
    current_email.click_link 'sign up'
  end

  def friend_creates_account
    fill_in 'Password', with: friend_attributes[:password]
    fill_in 'Full Name', with: friend_attributes[:full_name]
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '123'
    select '12 - December', from: 'date_month'
    select Date.today.year.to_s, from: 'date_year'
    click_button 'Sign Up'
  end

  def friend_signs_in
    fill_in 'email', with: friend_attributes[:email]
    fill_in 'password', with: friend_attributes[:password]
    click_button 'Sign In'
  end

  def signed_in_user_should_follow(other_user_name)
    click_link 'People'
    expect(page).to have_content other_user_name
  end
end