require 'spec_helper'

feature 'user signs in' do
  given(:user) { User.create(email: 'hello@leeduan.com', password: 'password', full_name: 'Lee Duan') }

  scenario 'with valid credentials' do
    visit signin_path
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'
    expect(page).to have_content user.full_name
  end

  scenario 'with invalid credentials' do
    visit signin_path
    fill_in 'Email Address', with: 'hacker@leeduan.com'
    fill_in 'Password', with: 'password'
    click_on 'Sign in'
    expect(page).to have_content('Invalid email or password')
  end
end