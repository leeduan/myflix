require 'spec_helper'

feature 'user resets password' do
  given(:user) { User.create(email: 'hello@leeduan.com', password: 'old_password', full_name: 'Lee Duan') }

  scenario 'user successfully resets the password' do
    visit signin_path
    click_link 'Forgot Password?'

    fill_in 'email', with: user.email
    click_button 'Send Email'

    open_email(user.email)
    current_email.click_link 'reset'

    fill_in 'password', with: 'new_password'
    fill_in 'password_confirmation', with: 'new_password'
    click_button 'Reset Password'

    fill_in 'email', with: user.email
    fill_in 'password', with: 'new_password'
    click_button 'Sign In'
    expect(page).to have_content('You are signed in, enjoy!')

    clear_emails
  end
end
