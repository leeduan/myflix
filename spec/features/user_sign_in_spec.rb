require 'spec_helper'

feature 'user signs in' do
  given(:user) { User.create(email: 'hello@leeduan.com', password: 'password', full_name: 'Lee Duan') }

  scenario 'with valid credentials' do
    sign_in(user)
    expect(page).to have_content user.full_name
  end

  scenario 'with invalid credentials' do
    fake_user = Fabricate(:user, password: 'password')
    fake_user.password = 'hacking_password'
    sign_in(fake_user)
    expect(page).to have_content('Invalid email or password')
  end
end