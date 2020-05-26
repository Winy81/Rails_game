require 'rails_helper'

RSpec.feature 'Create new user page' do

  scenario 'Should do not create user without all data' do

    visit '/users/sign_up'

    expect(page).to have_content('Sign up')

    fill_in 'user_email', with: 'test_user_reg@email.com'
    fill_in 'user_password', with: 'test_user_reg'
    fill_in 'user_password_confirmation', with: 'test_user_reg'

    click_button 'Sign up'

    expect(page).to have_content("Name can't be blank")

    expect(current_path).to eq(user_registration_path)
  end

  scenario 'Should do create user if all data provided include name' do

    visit '/users/sign_up'

    expect(page).to have_content('Sign up')
    
  end

end