require 'spec_helper'

feature 'user signs in' do
    scenario 'with valid credentials' do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content user.full_name
  end

  scenario 'with suspended user' do
    user = Fabricate(:user, suspended: true)
    sign_in(user)
    expect(page).to have_content('Unlimited Movies for Only 9.99')
    expect(page).to have_content('Sorry, your account has been suspended.')
  end

  scenario 'with invalid credentials' do
    fake_user = Fabricate(:user, password: 'password')
    fake_user.password = 'hacking_password'
    sign_in(fake_user)
    expect(page).to have_content('Invalid email or password')
  end
end
