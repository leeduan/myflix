require 'spec_helper'

feature 'user signs up', :js do

  background { visit getstarted_path }

  scenario 'with invalid user credentials', :vcr do
    fill_in_user_credentials
    fill_in_credit_card_with('4242424242424242')
    click_button 'Sign Up'
    expect(page).to have_content 'not a valid email address'
    expect(page).to have_content "can't be blank"
  end

  scenario 'with email credentials already taken', :vcr do
    Fabricate(:user, email: 'hello@leeduan.com')
    fill_in_user_credentials(email: 'hello@leeduan.com', password: 'password', full_name: 'Lee Duan')
    fill_in_credit_card_with('4242424242424242')
    click_button 'Sign Up'
    expect(page).to have_content 'has already been taken'
  end

  scenario 'with valid user credentials and declined card', :vcr do
    fill_in_user_credentials(email: 'hello@leeduan.com', password: 'password', full_name: 'Lee Duan')
    fill_in_credit_card_with('4000000000000002')
    click_button 'Sign Up'
    expect(page).to have_content "Your card was declined."
  end

  scenario 'with valid user credentials and expired card', :vcr do
    fill_in_user_credentials(email: 'hello@leeduan.com', password: 'password', full_name: 'Lee Duan')
    fill_in_credit_card_with('4000000000000069')
    click_button 'Sign Up'
    expect(page).to have_content "Your card's expiration date is incorrect."
  end

  scenario 'with valid user credentials and invalid card', :vcr do
    fill_in_user_credentials(email: 'hello@leeduan.com', password: 'password', full_name: 'Lee Duan')
    fill_in_credit_card_with('12345')
    click_button 'Sign Up'
    expect(page).to have_content "This card number looks invalid"
  end

  scenario 'with valid user credentials and valid card', :vcr do
    fill_in_user_credentials(email: 'hello@leeduan.com', password: 'password', full_name: 'Lee Duan')
    fill_in_credit_card_with('4242424242424242')
    click_button 'Sign Up'
    expect(page).to have_content 'Thank you for joining MyFLiX! Please sign in.'
  end
end

def fill_in_user_credentials(options={})
  fill_in 'Email', with: options[:email]
  fill_in 'Password', with: options[:password]
  fill_in 'Full Name', with: options[:full_name]
end

def fill_in_credit_card_with(card_number)
  fill_in 'Credit Card Number', with: card_number
  fill_in 'Security Code', with: '123'
  select '12 - December', from: 'date_month'
  select Date.today.year.to_s, from: 'date_year'
end