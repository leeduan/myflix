require 'spec_helper'

feature 'Admin sees payments' do
  let(:admin) { Fabricate(:user, email: 'hello@leeduan.com', admin: true) }
  let(:user) { Fabricate(:user) }
  background { Fabricate(:payment, user: admin, reference_id: 'id_12345') }

  scenario 'user cannot see payments' do
    Fabricate(:category)
    sign_in(user)
    visit admin_payments_path
    expect(page).to have_css('article.video_category')
    expect(page).to_not have_content('$9.99')
    expect(page).to_not have_content('hello@leeduan.com')
    expect(page).to_not have_content('id_12345')
  end

  scenario 'admin can see payments' do
    sign_in(admin)
    visit admin_payments_path
    expect(page).to have_content('$9.99')
    expect(page).to have_content('hello@leeduan.com')
    expect(page).to have_content('id_12345')
  end
end